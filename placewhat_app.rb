
set :app_file, __FILE__
set :public_folder, 'public'
set :static, true
set :root, File.dirname(__FILE__)

# placewhat, whatadver, whatholder, putapicon.it

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end

  def not_blank?
    not blank?
  end
end

class PlaceWhatApp < Sinatra::Application

  get '/:width/:height' do |width, height|
    place_what = PlaceWhat.new( :width => params[:width], 
                                :height => params[:height], 
                                :query => params[:q],
                                :seed => params[:seed],
                                :refresh => params[:refresh])
    place_what.run
    content_type 'image/jpg'
    send_file "./public#{place_what.random_image}" 
  end

  get '/:size' do |size|
    pass unless (size = params[:size].scan(/(\d+)x(\d+)/) and size.not_blank?)
    width, height = size.flatten

    place_what = PlaceWhat.new( :width => width, 
                                :height => height,
                                :query => params[:q],
                                :seed => params[:seed],
                                :refresh => params[:refresh])

    place_what.run
    content_type 'image/jpg'
    send_file "./public#{place_what.random_image}"
  end

  get '/:ad_size' do |ad_size|
    pass unless PlaceWhat::AD_TYPES.keys.include?(params[:ad_size])

    width, height = PlaceWhat::AD_TYPES[params[:ad_size]].split "x"

    place_what = PlaceWhat.new( :width => width, 
                                :height => height,
                                :query => params[:q],
                                :seed => params[:seed],
                                :refresh => params[:refresh])

    place_what.run
    content_type 'image/jpg'
    send_file "./public#{place_what.random_image}" 
  end
   
  get '/:square' do |square|
    pass unless params[:square].to_i > Image::MIN_SIZE and params[:square].to_i < Image::MAX_SIZE
    place_what = PlaceWhat.new( :width => params[:square], 
                                :height => params[:square],
                                :query => params[:q],
                                :seed => params[:seed],
                                :refresh => params[:refresh])
    place_what.run
    content_type 'image/jpg'
    send_file "./cache#{place_what.random_image}" 
  end

  get "/*" do 
    send_file "./public/index.html" 
  end

end