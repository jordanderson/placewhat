class PlaceWhat

  attr_accessor :width, :height, :images, :resized_images

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
    @query    = options[:query]
    @seed     = options[:seed]
    @refresh  = options[:refresh].not_blank? ? true : false

    @images         = []
    @resized_images = []
  end

  def normalize_query
    @query.gsub(/\s/, /\_/).downcase
  end

  def image_folder
    "./cache/images/#{@query}/#{@width}/#{@height}"
  end

  def original_folder
    "./cache/images/#{@query}/original"
  end

  def get_cached_images
    if stored_images = get_images and stored_images.size > 4
      @resized_images = stored_images
    elsif originals = Dir.glob("#{original_folder}/*.jpg") and originals.size > 4
      puts "Found originals, but not the requested size. Need to resize."
      @images = originals 
      size_images(:have_originals => true)
    end
    return @resized_images.not_blank? ? true : false
  end

  def random_image
    @resized_images.shuffle.first rescue nil
  end

  def retrieve_images
    g = Google::Search::Image.new(:query => @query, 
                                  :file_type => :jpg, 
                                  :safety_level => :off)

    if @seed.not_blank? and all_images = g.all.map {|i| i.uri }
      @images = all_images
    elsif response = g.get_hash and response.not_blank? and response["responseData"]["results"].not_blank?
      @images = response["responseData"]["results"].map {|i| i["url"] }
    else
      retrieve_images
    end
  end

  def self.size_image(blob, options={})
    mini_magick_image = MiniMagick::Image.read(blob)

    mini_magick_image.combine_options do |c|
      c.resize "#{options[:width]}x#{options[:height]}^"
      c.gravity "center"
      c.background "white"
      c.extent "#{options[:width]}x#{options[:height]}"
      c.strip
      c.colorspace "RGB"
    end

    mini_magick_image.to_blob
  end

  def image_key
    "placewhat:#{@query.gsub(/\W/, '_').downcase}/#{@width}/#{@height}"
  end

  def get_images
    JSON.parse(@redis.get(image_key)) rescue []
  end

  def set_images
    puts "Saving #{image_key}"
    @redis.set image_key, @resized_images.to_json
  end

  def write_file(blob, options = {})
    file_name = (('a'..'z').to_a + (0..9).to_a + ('A'..'Z').to_a).shuffle[0,8].join
    folder = options[:original].not_blank? ? original_folder : image_folder
    path = Pathname.new(folder)
    path.mkpath if !path.exist? 

    file = File.new(path.to_s + "/#{@query.gsub(/\W/, '_').downcase}_#{file_name}.jpg", "w")
    file.write(blob)
    file.close

    File.basename(file.path)
  end

  def size_images(options = {})
    images.each do |uri|
      begin
        blob = open(uri).read
        write_file(blob, :original => true) if options[:have_originals].blank?
        resized = PlaceWhat.size_image(blob, {:width => @width, :height => @height})
        @resized_images << "/images/#{@query}/#{@width}/#{@height}/#{write_file(resized)}"
      rescue => e
        puts "#{e}: #{e.backtrace}"
      end
    end
    set_images if @resized_images.not_blank? and @resized_images.size > 4
    true
  end

  def run(options={})
    if @refresh or !get_cached_images
      retrieve_images
      size_images
    end
  end

end