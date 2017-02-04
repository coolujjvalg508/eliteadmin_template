class AddTrashToGallery < ActiveRecord::Migration
  def change
  	add_column :galleries, :is_trash, :integer, :default => 0

  end
end
