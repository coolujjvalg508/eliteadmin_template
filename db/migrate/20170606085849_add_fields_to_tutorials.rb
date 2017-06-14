class AddFieldsToTutorials < ActiveRecord::Migration
  def change
  	add_column :tutorials,  :paramlink, :string
	add_column :tutorials, :tutorial_id, :string
	add_column :tutorials, :has_adult_content, :boolean
	add_column :tutorials, :number_of_sold, :integer, :default => 0
	add_column :tutorials, :like_count, :integer, :default => 0
	add_column :tutorials, :view_count, :integer, :default => 0
	add_column :tutorials, :comment_count, :integer, :default => 0
	add_column :tutorials, :follow_count, :integer, :default => 0
	add_column :tutorials, :zoom_w, :string
	add_column :tutorials, :zoom_h, :string
	add_column :tutorials, :zoom_x, :string
	add_column :tutorials, :zoom_y, :string
	add_column :tutorials, :drag_x, :string
	add_column :tutorials, :drag_y, :string
	add_column :tutorials, :rotation_angle, :string
	add_column :tutorials, :crop_x, :string
	add_column :tutorials, :crop_y, :string
	add_column :tutorials, :crop_w, :string
	add_column :tutorials, :crop_h, :string
	add_column :tutorials, :is_trash, :integer, :default => 0
	add_column :tutorials, :use_tag_from_previous_upload, :boolean, :default => false
	add_column :tutorials, :is_spam, :boolean, :default => false
	add_column :tutorials, :sub_sub_topic, :json
  end
end
