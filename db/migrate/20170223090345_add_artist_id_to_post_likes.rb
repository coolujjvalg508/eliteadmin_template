class AddArtistIdToPostLikes < ActiveRecord::Migration
  def change
  	add_column :post_likes, :artist_id, :integer
  end
end
