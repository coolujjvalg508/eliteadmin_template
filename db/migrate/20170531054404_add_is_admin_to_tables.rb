class AddIsAdminToTables < ActiveRecord::Migration
  def change
  		add_column :post_likes, :is_admin, :string
		add_column :notifications, :is_admin, :string
		add_column :latest_activities, :is_admin, :string
		add_column :follows, :is_admin, :string
		
		add_column :post_comments, :is_admin, :string

		add_column :admin_users, :like_count, :integer, :default => 0
		add_column :admin_users, :view_count, :integer, :default => 0
		add_column :admin_users, :follow_count, :integer, :default => 0
  end
end
