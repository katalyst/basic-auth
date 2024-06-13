# frozen_string_literal: true

require "active_support/string_inquirer"

class DummyRails
  module VERSION
    MAJOR = 4
  end

  class Application
    class << self
      def module_parent_name
        self
      end

      def parent_name
        self
      end

      def underscore
        "app"
      end
    end
  end

  class << self
    def application
      Application.new
    end

    def env
      @env ||= ActiveSupport::StringInquirer.new("development")
    end

    def env=(value)
      @env = ActiveSupport::StringInquirer.new(value)
    end
  end
end
