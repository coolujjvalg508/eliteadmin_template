class AddCoverArtToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :cover_art_image, :string
  end
end
