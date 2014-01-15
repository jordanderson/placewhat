require 'rubygems' 
require 'bundler'  

Bundler.require  
require './placewhat_app.rb' 
require './environment.rb'
require 'sidekiq/web'

run Rack::URLMap.new('/' => PlaceWhatApp.new, '/sidekiq' => Sidekiq::Web)