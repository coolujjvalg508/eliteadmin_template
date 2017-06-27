class AddFieldsToNews < ActiveRecord::Migration
  def change
  		add_column :news, :has_adult_content, :boolean
		add_column :news, :like_count, :integer, :default => 0
		add_column :news, :view_count, :integer, :default => 0
		add_column :news, :zoom_w, :string
		add_column :news, :zoom_h, :string
		add_column :news, :zoom_x, :string
		add_column :news, :zoom_y, :string
		add_column :news, :drag_x, :string
		add_column :news, :drag_y, :string
		add_column :news, :rotation_angle, :string
		add_column :news, :crop_x, :string
		add_column :news, :crop_y, :string
		add_column :news, :crop_w, :string
		add_column :news, :crop_h, :string
		add_column :news, :is_trash, :integer, :default => 0
		add_column :news, :use_tag_from_previous_upload, :boolean, :default => false
		add_column :news, :is_spam, :boolean, :default => false
		add_column :news, :is_approved, :boolean, :default => true
		add_column :news, :package_id, :json
  end
end
