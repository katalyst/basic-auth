# frozen_string_literal: true

require "digest"

module Katalyst
  module Basic
    module Auth
      class Config
        class << self
          def enabled?
            enable = ENV.fetch("KATALYST_BASIC_AUTH_ENABLED", enabled_rails_env?)
            [true, "yes", "true"].include?(enable)
          end

          def username
            ENV["KATALYST_BASIC_AUTH_USER"] || default_username
          end

          def password
            ENV["KATALYST_BASIC_AUTH_PASS"] || default_password
          end

          private

          def enabled_rails_env?
            return false unless rails?

            Rails.env.staging? || Rails.env.uat?
          end

          def rails?
            defined?(Rails)
          end

          def default_username
            return "katalyst" unless rails?

            if Rails::VERSION::MAJOR >= 6
              Rails.application.class.module_parent_name.underscore
            else
              Rails.application.class.parent_name.underscore
            end
          end

          def default_password
            Digest::SHA256.hexdigest("#{default_password_salt}#{default_username}")[0..15]
          end

          def default_password_salt
            if rails? && Rails.application.respond_to?(:secret_key_base)
              Rails.application.secret_key_base
            else
              ENV["SECRET_KEY_BASE"]
            end
          end
        end
      end
    end
  end
end
