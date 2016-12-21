class MarmoSet < ActiveRecord::Base
mount_uploader :marmoset, MarmosetUploader
	attr_accessor :tmp_marmoset
	belongs_to :marmosetable, polymorphic: false 
end
