# frozen_string_literal: true

class DummyRailsEnv
  ENVIRONMENTS = %w[production development staging uat].freeze

  attr_accessor :value

  ENVIRONMENTS.each do |env|
    define_method("#{env}?") do
      value == env
    end
  end
end
