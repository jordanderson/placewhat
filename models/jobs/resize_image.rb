# -*- encoding : utf-8 -*-
class ResizeImage
  include Sidekiq::Worker

  def image_key(query, width, height)
    "placewhat:#{PlaceWhat.normalize_query(query)}/#{width}/#{height}"
  end

  def perform(path, query, width, height)
    image = Image.new(path, {:width => width, :height => height, :query => query})
    image.read_write_resize

    redis = Redis.new
    image_paths = JSON.parse(redis.get(image_key(query, width, height))) rescue []
    image_paths << image.resized_path
    redis.set image_key(query, width, height), image_paths.uniq.to_json

    puts "Saving #{image_key(query, width, height)} with #{image_paths.uniq.size.to_i} images\n"

  end
end