# require 'rubygems' 
# require 'bundler'  
# require 'bundler/setup'

# Bundler.require(:default) 
require './environment.rb' 

require './placewhat_app.rb' 
require 'sidekiq/web'

run Rack::URLMap.new('/' => PlaceWhatApp.new, '/sidekiq' => Sidekiq::Web)