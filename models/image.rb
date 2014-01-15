class Image

  MAX_SIZE = 1800
  MIN_SIZE = 16

  attr_accessor :width, :height, :query, :uri, :blob, :resized_path, :base_name

  def self.filename(q)
    generated_name = (('a'..'z').to_a + (0..9).to_a + ('A'..'Z').to_a).shuffle[0,8].join
    "/#{PlaceWhat.normalize_query(q)}_#{generated_name}.jpg"
  end

  def initialize(uri, options={})
    @uri          = uri
    @width        = options[:width]
    @height       = options[:height]
    @query        = options[:query]
    @resized_path = ""
    @base_name    = ""
  end

  # Abbreviation for ":normalized_query/:width/:height"
  def qwh
    "#{PlaceWhat.normalize_query(@query)}/#{@width}/#{@height}"
  end

  def image_folder
    "./cache/images/#{qwh}"
  end

  def original_folder
    "./cache/images/#{PlaceWhat.normalize_query(@query)}/original"
  end

  def path_to_image(file_name)
    "/images/#{qwh}/#{file_name}"
  end

  def read_write_resize
    begin
      blob = open(uri).read
      write_original_file(blob) if needs_original?
      write_resized_file(size_image(blob))
    rescue => e
      puts "#{e}: #{e.backtrace}"
    end
  end

  def write_original_file(blob)
    write_file(blob, original_folder)
  end

  def write_resized_file(blob)
    write_file(blob, image_folder)
  end

  def write_file(blob, folder)
    file_name = Image.filename(@query)
    path = Pathname.new(folder)
    path.mkpath if !path.exist? 

    file = File.new(path.to_s + file_name, "w")
    file.write(blob)
    file.close

    @base_name = File.basename(file.path)
    @resized_path = path_to_image(@base_name)
  end

  def size_image(blob)
    mini_magick_image = MiniMagick::Image.read(blob)

    mini_magick_image.combine_options do |c|
      c.resize "#{width}x#{height}^"
      c.gravity "center"
      c.background "white"
      c.extent "#{width}x#{height}"
      c.strip
      c.colorspace "RGB"
    end

    mini_magick_image.to_blob
  end

  def needs_original?
    uri.match(/^http/)
  end

end