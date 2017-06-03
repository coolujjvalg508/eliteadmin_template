class AddSomeFieldsToDownloads < ActiveRecord::Migration
  def change
  	add_column :downloads, :license_type, :string
	  add_column :downloads, :has_adult_content, :boolean
	  add_column :downloads, :license_custom_info, :string
	  add_column :downloads, :number_of_download, :integer
	  add_column :downloads, :number_of_sold, :integer
	  add_column :downloads, :like_count, :integer, :default => 0
	  add_column :downloads, :view_count, :integer, :default => 0
	  add_column :downloads, :comment_count, :integer, :default => 0
	  add_column :downloads, :follow_count, :integer, :default => 0
	  add_column :downloads, :zoom_w, :string
  	add_column :downloads, :zoom_h, :string
  	add_column :downloads, :zoom_x, :string
  	add_column :downloads, :zoom_y, :string
  	add_column :downloads, :drag_x, :string
  	add_column :downloads, :drag_y, :string
  	add_column :downloads, :rotation_angle, :string
  	add_column :downloads, :crop_x, :string
  	add_column :downloads, :crop_y, :string
  	add_column :downloads, :crop_w, :string
  	add_column :downloads, :crop_h, :string
  	add_column :downloads, :show_on_cgmeetup, :boolean
  	add_column :downloads, :show_on_website, :boolean
    add_column :downloads, :is_trash, :integer, :default => 0
    add_column :downloads, :unit, :string
    add_column :downloads, :use_tag_from_previous_upload, :boolean, :default => false
  	add_column :downloads, :is_spam, :boolean, :default => false
  end
end
