require 'rubygems' 
require 'bundler'  
require 'bundler/setup'

Bundler.require(:default) 
require 'sidekiq'
require 'open-uri'
Dir["./models/**/*.rb"].each {|file| require file}
