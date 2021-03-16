# frozen_string_literal: true

namespace :katalyst_basic_auth do
  desc "Display basic auth information for the app"
  task :info do
    config = Katalyst::Basic::Auth::Config
    puts "Basic auth settings:"
    puts "enabled: #{config.enabled?}"
    puts "username: #{config.username}"
    puts "password: #{config.password}"
  end
end
