# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
   include CarrierWave::RMagick
   include CarrierWave::MiniMagick


  # Choose what kind of storage to use for this uploader:
  storage :file

  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  #  abort("uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}")
  end

   version :mini_magick do
      process :resize_and_crop

  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
 version :thumb do
    process :resize_to_fill => [100, 100]
  end
  
  version :medium do
    process :resize_to_fill => [300, 300]
  end
  
  version :event_small do
    process :resize_to_fill => [219, 219]
  end

  version :large_image do
    process :resize_to_fill => [730, 370]
  end

  version :download_list do
    process :resize_to_fill => [270, 270]
  end

  version :tutorial_list do
    process :resize_to_fill => [270, 160]
  end

  version :software_used do
    process :resize_to_fill => [28, 28]
  end

  version :browse_art_work do
    process :resize_to_fill => [500, 500]
  end

  version :user_activity do
    process :resize_to_fill => [50, 50]
  end
   version :art_activity do
    process :resize_to_fill => [626, 404]
  end


/ 
  version :carousel do
    process :resize_to_fill => [372, 372]
  end
  
  version :recent_photo do
    process :resize_to_fill => [234, 234]
  end

  version :home_blog do
    process :resize_to_fill => [270, 183]
  end
 
  version :profile do
    process :resize_to_fill => [128, 128]
  end

  version :ad_horizontal do
    process :resize_to_fill => [1140, 98]
  end

  version :ad_square do
    process :resize_to_fill => [360, 382]
  end

  version :card_image do
    process :resize_to_fill => [180, 180]
  end

  /

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_white_list
     %w(jpg jpeg gif png tif tiff bmp)
   end


  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
#def filename
  #   "something.jpg" if original_filename
    
 # end



  def resize_and_crop
    #abort(model.to_json)
    if model.class.to_s == "Gallery"
        if model.crop_x.present?
          #abort('gdfsgg')

              manipulate! do |img| 
                #abort(current_path)

                  
                    w = model.crop_w.to_i
                    h = model.crop_h.to_i
                

                 # abort(w.to_s)
          
                   x = model.zoom_x.to_i >= 0 ? (model.crop_x.to_i - model.zoom_x.to_i) : (model.zoom_x.to_i.abs + model.crop_x.to_i)
                    y = model.zoom_y.to_i >= 0 ? (model.crop_y.to_i - model.zoom_y.to_i) : (model.zoom_y.to_i.abs + model.crop_y.to_i)


                    x = model.drag_x.to_i >= 0 ? (x - model.drag_x.to_i) : (model.drag_x.to_i.to_i.abs + x) 
                    y = model.drag_y.to_i >= 0 ? (y - model.drag_y.to_i) : (model.drag_y.to_i.to_i.abs + y) 
                
                    # abort("#{model.zoom_w.to_i}x#{model.zoom_h.to_i}+#{model.zoom_x.to_i}+#{model.zoom_y.to_i}")

                   # abort("#{w}x#{h}+#{x}+#{y}")
                    img.combine_options do |i|
                     
                      #system('mogrify -resize #{model.zoom_w.to_i}x#{model.zoom_h.to_i}+#{model.zoom_x.to_i}+#{model.zoom_y.to_i}'+i)
                     
                     # system('mogrify -rotate #{model.rotation_angle.to_i}'+current_path)
                    # system('mogrify -crop #{w}x#{h}+#{x}+#{y}'+current_path)
                      
                     
                      i.resize "#{model.zoom_w.to_i}x#{model.zoom_h.to_i}+#{model.zoom_x.to_i}+#{model.zoom_y.to_i}"
                     #i.rotate(model.rotation_angle.to_i)
                      i.crop "#{w}x#{h}+#{x}+#{y}"
                    end
               img
               # abort(img)
              end
          end
        end
     end 

end
