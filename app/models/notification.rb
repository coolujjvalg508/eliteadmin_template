class Notification < ActiveRecord::Base

	belongs_to :user, :foreign_key =>"user_id"
 	belongs_to :user, :foreign_key =>"artist_id"
 	belongs_to :gallery, :foreign_key =>"post_id"
end
