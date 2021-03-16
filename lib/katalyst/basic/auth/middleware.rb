module Katalyst
  module Basic
    module Auth
      class Middleware

        attr_reader :app

        class << self
          def enabled?
            !ENV["KATALYST_BASIC_AUTH_ENABLED"].nil? &&
              !%w[0 false].include?(ENV["KATALYST_BASIC_AUTH_ENABLED"])
          end
        end

        def initialize(app)
          @app = app
        end

        def call(env)
          if enabled?
            auth = Rack::Auth::Basic.new(app) do |u, p|
              u == username && p == password
            end
            auth.call env
          else
            app.call env
          end
        end

        def username
          ENV["KATALYST_BASIC_AUTH_USER"] || default_username
        end

        def default_username
          if Object.const_defined?("Rails")
            Rails.application.class.parent_name.underscore
          else
            app.class.parent_name.underscore
          end
        end

        def password
          ENV["KATALYST_BASIC_AUTH_PASS"] || default_password
        end

        def default_password
          Digest::MD5.hexdigest(default_username)
        end

        def enabled?
          self.class.enabled?
        end
      end
    end
  end
end
