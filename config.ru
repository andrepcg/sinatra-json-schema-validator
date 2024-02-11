ENV["RUBY_ENV"] ||= "development"

if ENV["RUBY_ENV"] == "development"
  require 'rack/unreloader'
  require 'sinatra'
  Unreloader = Rack::Unreloader.new{Application}
  Unreloader.require './app.rb'

  run Unreloader
else
  require './app'
  run Application
end
