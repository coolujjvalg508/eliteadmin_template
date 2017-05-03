class AddFieldsToJobs < ActiveRecord::Migration
  def change
	  	add_column :jobs, :zoom_w, :string
	  	add_column :jobs, :zoom_h, :string
	  	add_column :jobs, :zoom_x, :string
	  	add_column :jobs, :zoom_y, :string
	  	add_column :jobs, :drag_x, :string
	  	add_column :jobs, :drag_y, :string
	  	add_column :jobs, :rotation_angle, :string
	  	add_column :jobs, :crop_x, :string
	  	add_column :jobs, :crop_y, :string
	  	add_column :jobs, :crop_w, :string
	  	add_column :jobs, :crop_h, :string
	  	add_column :jobs, :is_trash, :integer, :default => 0
	  	add_column :jobs, :like_count, :integer, :default => 0
	  	add_column :jobs, :view_count, :integer, :default => 0
	  	add_column :jobs, :comment_count, :integer, :default => 0
	  	add_column :jobs, :follow_count, :integer, :default => 0
  end
end
