class UploadVideo < ActiveRecord::Base
	mount_uploader :uploadvideo, VideoUploader
	attr_accessor :tmp_uploadvideo
	belongs_to :uploadvideoable, polymorphic: false 

end
