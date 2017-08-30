class UploadVideo < ActiveRecord::Base
	mount_uploader :uploadvideo, VideoUploader
	attr_accessor :tmp_uploadvideo
	#belongs_to :uploadvideoable, polymorphic: false


	#after_save :create_thumbnail



	#def create_thumbnail

	#	data = self
	#	require 'streamio-ffmpeg'

	#	path = Rails.public_path.to_s + data.uploadvideo.url.to_s
	#	dir_path = File.dirname(path)

	#	movie = FFMPEG::Movie.new(path)
	#	a = movie.screenshot("#{dir_path}/thumbnail.jpg", :seek_time => 2)

	#end

	def self.sitemap_videos
		result = []
		videos = self.all
		if videos.present?
			videos.each do |v|
				if v.uploadvideo.present?
					result << {
				    title: v.caption_upload_video,
				    content_loc: ENV['HOST_URL'] + v.uploadvideo.url
				  }
				end
			end
		end
		result
	end

end
