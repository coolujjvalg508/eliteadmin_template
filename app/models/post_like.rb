class PostLike < ActiveRecord::Base
	belongs_to :gallery, :foreign_key =>"post_id"
end
