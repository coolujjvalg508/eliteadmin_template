class Image < ActiveRecord::Base
	mount_uploader :image, ImageUploader
	attr_accessor :tmp_image
	#belongs_to :imageable, polymorphic: false

	def self.sitemap_images
		images = self.all
		result = []
		if images.present?
			images.each do |i|
				if i.image.present?
					result << {title: i.caption_image, loc: i.image.url}
				end
			end
		end
		result
	end
end
