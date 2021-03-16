namespace :katalyst_basic_auth do
  desc "Display basic auth information for the app"
  task :info do
    middleware = Katalyst::Basic::Auth::Middleware.new(Rails.application)
    puts "Basic auth enabled: #{middleware.enabled?}"
    puts "username: #{middleware.username}"
    puts "password: #{middleware.password}"
  end
end
