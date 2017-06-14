class MediaContent < ActiveRecord::Base
	#abort('fdf')
		mount_uploader :mediacontent, MediaUploader
		attr_accessor :tmp_mediacontent

 		MEDIA_CONTENT_TYPE = ['Upload Image','Upload Video', 'Upload Zip', 'Upload Marmoset','Video Url','Sketchfab Url','Description']
end
