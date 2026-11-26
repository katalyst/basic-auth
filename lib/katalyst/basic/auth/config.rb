# frozen_string_literal: true

require "digest"
require "ipaddr"
require "rack"

module Katalyst
  module Basic
    module Auth
      class Config # rubocop:disable Metrics/ClassLength
        DEFAULT_USERNAME = "katalyst"
        ROOT_PATH        = "/"

        class << self
          include Enumerable

          # @param path [String] Request path
          # @return [Config] The last rule added that matches the given path
          def for_path(path)
            path = normalize_path(path)
            all.rfind { |i| i.match?(path) }
          end

          # Compare paths the way the Rails router will see them, e.g. "//admin" routes to "/admin"
          # @param path [String, nil] Request path
          # @return [String] Path with repeated slashes collapsed
          def normalize_path(path)
            "/#{path}".squeeze("/")
          end

          # @return [Config] The global configuration
          def global
            all.first
          end

          # Adds a rule that takes priority over the rules added before it
          # @param path [String, Regexp] Relative path, or a pattern that must match the whole request path
          # @param username [String] Basic auth user name
          # @param password [String] Basic auth password
          # @param enabled [Boolean] True to enable basic auth for this path
          # @param ip_allowlist [Array<String>] List of IP addresses or network ranges to allow without basic auth
          def add(path:, username: nil, password: nil, enabled: nil, ip_allowlist: nil)
            config = new(
              path:         path,
              username:     username,
              password:     password,
              enabled:      enabled,
              ip_allowlist: ip_allowlist,
            )
            all << config
            config
          end

          def up(path = "/up")
            new(path: path, enabled: false)
          end

          # @return [Array<Config>] Rules in the order they were added, starting with the global configuration and
          #   the Rails health check
          def all
            @all ||= [new, up]
          end

          def reset!
            @all = nil
          end

          def each(&)
            all.each(&)
          end

          def description
            output = ["Basic auth settings:", ""]
            all.each do |config|
              output << config.description
              output << ""
            end
            output.join("\n")
          end

          def enabled?
            global_enabled = ENV.fetch("KATALYST_BASIC_AUTH_ENABLED", enabled_rails_env?)
            [true, "yes", "true"].include?(global_enabled)
          end

          def enabled_rails_env?
            return false unless rails?

            %w[staging uat].include?(Rails.env)
          end

          def rails?
            defined?(Rails)
          end

          def default_username
            return ENV["KATALYST_BASIC_AUTH_USER"] if ENV["KATALYST_BASIC_AUTH_USER"]
            return DEFAULT_USERNAME unless rails?

            if Rails::VERSION::MAJOR >= 6
              Rails.application.class.module_parent_name.underscore
            else
              Rails.application.class.parent_name.underscore
            end
          end

          def default_password(username)
            return ENV["KATALYST_BASIC_AUTH_PASS"] if ENV["KATALYST_BASIC_AUTH_PASS"]

            Digest::SHA256.hexdigest("#{default_password_salt}#{username}")[0..15]
          end

          def default_password_salt
            if rails? && Rails.application.respond_to?(:secret_key_base)
              Rails.application.secret_key_base
            else
              ENV.fetch("SECRET_KEY_BASE", nil)
            end
          end

          def default_ip_allowlist
            ENV.fetch("KATALYST_BASIC_AUTH_IP_ALLOWLIST", "").split(/[\s,]+/)
          end
        end

        attr_reader :path, :username, :password, :ip_allowlist

        def enabled?
          @enabled
        end

        def root_path?
          path == ROOT_PATH
        end

        def pattern?
          path.is_a?(Regexp)
        end

        # Paths match themselves and anything below them, on path segment boundaries,
        # e.g. "/up" matches "/up" and "/up/db" but not "/uploads".
        # Patterns must match the whole request path, e.g. %r{/clients/[^/]+/webhooks/[^/]+}.
        # @param request_path [String] Normalized request path
        def match?(request_path)
          return /\A(?:#{path})\z/.match?(request_path) if pattern?

          request_path == path || request_path.start_with?("#{path.chomp('/')}/")
        end

        def allow_ip?(env)
          request = ::Rack::Request.new(env)
          return false unless request.ip

          remote_ip = IPAddr.new(request.ip)
          ip_allowlist.any? { |i| i.include?(remote_ip) }
        end

        def description
          output = []
          output << "path:         #{root_path? ? '(global)' : path_description}"
          output << "enabled:      #{enabled?}"
          output << "username:     #{username}"
          output << "password:     #{password}"
          output << "ip allowlist: #{ip_allowlist.inspect}"
          output.join("\n")
        end

        private

        def path_description
          pattern? ? path.inspect : path
        end

        # @param path [String, Regexp] Relative path, or a pattern that must match the whole request path
        # @param username [String] Basic auth user name
        # @param password [String] Basic auth password
        # @param enabled [Boolean] True to enable basic auth for this path
        # @param ip_allowlist [Array<String>] List of IP addresses or network ranges to allow without basic auth
        def initialize(path: nil, username: nil, password: nil, enabled: nil, ip_allowlist: nil)
          @path         = sanitize_path(path)
          @username     = username || self.class.default_username
          @password     = password || self.class.default_password(@username)
          @enabled      = enabled.nil? ? (!root_path? || self.class.enabled?) : enabled
          @ip_allowlist = initialize_ip_allowlist(ip_allowlist)
        end

        def sanitize_path(path)
          return ROOT_PATH if path.nil?
          return path if path.is_a?(Regexp)

          path = "/#{path}" unless path.start_with?("/")
          path == ROOT_PATH ? path : path.chomp("/")
        end

        def initialize_ip_allowlist(ip_allowlist)
          (ip_allowlist || self.class.default_ip_allowlist).map { |i| IPAddr.new(i) }
        end
      end
    end
  end
end
