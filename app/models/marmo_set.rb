class MarmoSet < ActiveRecord::Base
mount_uploader :marmoset, VideoUploader
	attr_accessor :tmp_marmoset
	belongs_to :marmosetable, polymorphic: false 
end
