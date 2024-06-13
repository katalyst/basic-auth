# frozen_string_literal: true

require "bundler/setup"
require "bundler/gem_tasks"

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new

require "rubocop/rake_task"
RuboCop::RakeTask.new

task default: %i[rubocop spec] do
  puts "🎉 build complete! 🎉"
end
