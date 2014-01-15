# -*- encoding : utf-8 -*-
#!/usr/bin/env ruby
require "pathname"
require Pathname(File.expand_path __FILE__).dirname.parent.to_s + "/config.ru"
Dir["#{Pathname(__FILE__).dirname.parent.to_s}/models/*.rb"].each {|file| require file}

puts "Seeding #{ARGV[0]} at size 120x600"
place_what = PlaceWhat.new( :width => 120, 
                              :height => 600,
                              :query => ARGV[0],
                              :seed => true,
                              :refresh => true)

place_what.run

ad_types = PlaceWhat::AD_TYPES
ad_types.delete "skyscraper"

ad_types.values.each do |size|
  puts "Seeding #{ARGV[0]} at size #{size}"
  width, height = size.split("x")
  place_what = PlaceWhat.new( :width => width, 
                              :height => height,
                              :query => ARGV[0])
  place_what.run
end