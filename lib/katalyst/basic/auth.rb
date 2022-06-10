# frozen_string_literal: true

require_relative "auth/version"
require_relative "auth/config"
require_relative "auth/middleware"
require_relative "auth/rails" if defined?(Rails)

module Katalyst
  module Basic
    module Auth
      class << self
        # Add a path to be protected by basic authentication
        # @param path [String] Relative path
        # @param username [String] Basic auth user name
        # @param password [String] Basic auth password
        # @param ip_allowlist [Array<String>] List of IP addresses or network ranges to allow without basic auth
        def add(path, username: nil, password: nil, ip_allowlist: nil)
          Config.add(path:         path,
                     username:     username,
                     password:     password,
                     enabled:      true,
                     ip_allowlist: ip_allowlist)
        end

        # Add a path to be excluded from basic authentication
        # @param path [String] Relative path
        def exclude(path)
          Config.add(path: path, enabled: false)
        end
      end
    end
  end
end
