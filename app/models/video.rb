class Video < ActiveRecord::Base
    attr_accessor :tmp_video
	#belongs_to :videoable, polymorphic: false

  def self.sitemap_videos
    result = []
    videos = self.all
    if videos.present?
			videos.each do |v|
				result << {
			    title: v.caption_video,
			    content_loc: v.video
			  }
			end
		end
		result
  end
end
