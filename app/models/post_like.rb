class PostLike < ActiveRecord::Base
	belongs_to :gallery, :foreign_key =>"post_id"
	belongs_to :user, :foreign_key =>"user_id"
end
