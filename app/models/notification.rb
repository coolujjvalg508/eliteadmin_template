class Notification < ActiveRecord::Base

	belongs_to :user, :class_name => "User", :foreign_key =>"user_id"
 	belongs_to :artist, :class_name => "User", :foreign_key =>"artist_id"
 	belongs_to :gallery, :foreign_key =>"post_id"
 	belongs_to :download, :foreign_key =>"post_id"
end
