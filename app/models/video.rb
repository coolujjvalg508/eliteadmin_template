class Video < ActiveRecord::Base
    attr_accessor :tmp_video
	#belongs_to :videoable, polymorphic: false 
end
