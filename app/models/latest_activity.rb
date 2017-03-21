class LatestActivity < ActiveRecord::Base
	 belongs_to :gallery, :foreign_key =>"post_id"
	 belongs_to :user_detail, :class_name => "User", :foreign_key => "user_id"
     belongs_to :artist_detail, :class_name => "User", :foreign_key => "artist_id"

end
