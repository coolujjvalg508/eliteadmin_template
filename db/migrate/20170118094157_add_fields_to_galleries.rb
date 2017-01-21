class AddFieldsToGalleries < ActiveRecord::Migration
  def change
  	add_column :galleries, :zoom_w, :string
  	add_column :galleries, :zoom_h, :string
  	add_column :galleries, :zoom_x, :string
  	add_column :galleries, :zoom_y, :string
  	add_column :galleries, :drag_x, :string
  	add_column :galleries, :drag_y, :string
  	add_column :galleries, :rotation_angle, :string
  	add_column :galleries, :crop_x, :string
  	add_column :galleries, :crop_y, :string
  	add_column :galleries, :crop_w, :string
  	add_column :galleries, :crop_h, :string
  end
end
