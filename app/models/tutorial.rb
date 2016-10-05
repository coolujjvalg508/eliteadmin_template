class Tutorial < ActiveRecord::Base
 mount_uploader :image, ImageUploader 
 mount_uploader :video, VideoUploader
 
 validates :title, presence: true
 validates :paramlink, presence: true
end
