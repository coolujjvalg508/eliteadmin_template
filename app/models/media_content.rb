class MediaContent < ActiveRecord::Base
	#abort('fdf')
		default_scope { order(id: :ASC) }
		mount_uploader :mediacontent, MediaUploader
		attr_accessor :tmp_mediacontent

 		MEDIA_CONTENT_TYPE = ['Upload Image', 'Upload Video', 'Upload Zip', 'Upload Marmoset', 'Video Url', 'Sketchfab Url', 'Description']
end
