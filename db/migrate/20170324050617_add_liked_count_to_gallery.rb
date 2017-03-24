class AddLikedCountToGallery < ActiveRecord::Migration
  def change
  	add_column :galleries, :like_count, :integer, :default => 0
  	add_column :galleries, :comment_count, :integer, :default => 0
  end
end
