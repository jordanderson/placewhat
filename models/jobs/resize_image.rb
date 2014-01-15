# -*- encoding : utf-8 -*-
class ResizeImage
  include Sidekiq::Worker

  def perform(path, query, width, height)
    puts 'Doing hard work'
  end
end