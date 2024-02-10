# require './app'
# run Sinatra::Application

require 'rack/unreloader'
Unreloader = Rack::Unreloader.new{Sinatra::Application}
Unreloader.require './app.rb'

run Unreloader