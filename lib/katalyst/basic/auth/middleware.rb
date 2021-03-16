# frozen_string_literal: true

module Katalyst
  module Basic
    module Auth
      class Middleware
        attr_reader :app

        def initialize(app)
          @app = app
        end

        def call(env)
          auth = Rack::Auth::Basic.new(app) do |u, p|
            u == Config.username && p == Config.password
          end
          auth.call env
        end
      end
    end
  end
end
