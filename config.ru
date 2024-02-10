
if ENV["RUBY_ENV"] == "development"
  require 'rack/unreloader'
  Unreloader = Rack::Unreloader.new{Sinatra::Application}
  Unreloader.require './app.rb'

  run Unreloader
else
  require './app'
  run Sinatra::Application
end
