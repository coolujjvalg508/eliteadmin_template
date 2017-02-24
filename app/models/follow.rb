class Follow < ActiveRecord::Base
	 belongs_to :user, :class_name => "User", :foreign_key => "user_id"
     belongs_to :artist, :class_name => "User", :foreign_key => "artist_id"
end
