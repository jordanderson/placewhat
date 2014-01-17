class PlaceWhat

  attr_accessor :width, :height, :image_paths, :resized_images, :images

  AD_TYPES = {"skyscraper"        => "120x600", 
              "halfpage"          => "300x600", 
              "leaderboard"       => "728x90",
              "mediumrectangle"   => "300x250",
              "squarepopup"       => "250x250",
              "verticalrectangle" => "240x400",
              "largerectangle"    => "336x280",
              "rectangle"         => "180x150",
              "popunder"          => "720x300",
              "fullbanner"        => "468x60",
              "halfbanner"        => "234x60",
              "microbar"          => "88x31",
              "button1"           => "120x90",
              "button2"           => "120x60",
              "verticalbanner"    => "120x240",
              "squarebutton"      => "125x125",
              "wideskyscraper"    => "60x600" }

  def initialize(options={})
    @redis    = Redis.new
    @width    = options[:width]
    @height   = options[:height]
    @query    = options[:query].gsub("_", " ") rescue "puppies"
    @seed     = options[:seed]
    @refresh  = options[:refresh].not_blank? ? true : false
    @safe     = options[:safe].not_blank? ? :off : :active

    @image_paths    = []
    @images         = []
    @resized_images = []
  end

  def seeding_images?
    @seed.not_blank?
  end 

  def self.normalize_query(q)
    q.gsub(/\s+|\W+/, "_").downcase
  end

  def original_folder
    "./cache/images/#{PlaceWhat.normalize_query(@query)}/original"
  end

  def paths_to_local_originals
    Dir.glob("#{original_folder}/*.jpg") 
  end

  def get_cached_images
    if stored_images = get_images and stored_images.size > 4
      @resized_images = stored_images

    elsif originals = paths_to_local_originals and originals.size > 4
      puts "Found originals, but not the requested size. Need to resize."
      @image_paths = originals 
      process_images(:have_originals => true)
    end

    return @resized_images.not_blank? ? true : false
  end

  def random_image
    @resized_images.shuffle.first rescue nil
  end

  def retrieve_images
    g = Google::Search::Image.new(:query => @query, 
                                  :file_type => :jpg,
                                  :image_size => :xlarge, 
                                  :safety_level => @safe)

    if seeding_images? and all_images = g.map {|i| i.uri }.uniq
      @image_paths = all_images

    else
      # We get slightly more than 8 in case there are some duplicates
      @image_paths = g.first(15).map {|i| i.uri }.uniq.first(8)

    end
  end

  def image_key
    "placewhat:#{PlaceWhat.normalize_query(@query)}/#{@width}/#{@height}"
  end

  def get_images
    JSON.parse(@redis.get(image_key)).reject {|i| i.blank? } rescue []
  end

  def set_images
    puts "Saving #{image_key}"
    @redis.set(image_key, @resized_images.to_json)
  end

  def image_options
    {:width => @width, :height => @height, :query => @query}
  end

  def process_images(options = {})
    image_paths[0..0].each do |uri|
      begin
        image = Image.new(uri, image_options)
        image.read_write_resize
        @resized_images << image.resized_path

      rescue => e
        puts "#{e}: #{e.backtrace}"

      end
    end

    set_images if @resized_images.not_blank?

    image_paths[1..-1].each do |uri|
      begin
        ResizeImage.perform_async(uri, @query, @width, @height)

      rescue => e
        puts "#{e}: #{e.backtrace}"

      end
    end
    
    true
  end

  def run(options={})
    if @refresh or !get_cached_images or seeding_images?
      retrieve_images
      process_images
    end
  end

end