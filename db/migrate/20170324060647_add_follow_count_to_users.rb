class AddFollowCountToUsers < ActiveRecord::Migration
  def change
  	 add_column :users, :follow_count, :integer, :default => 0
  	 add_column :users, :view_count, :integer, :default => 0
  	 add_column :users, :like_count, :integer, :default => 0
  end
end
