# frozen_string_literal: true

require_relative "auth/version"
require_relative "auth/config"
require_relative "auth/middleware"
require_relative "auth/rails" if defined?(Rails)
