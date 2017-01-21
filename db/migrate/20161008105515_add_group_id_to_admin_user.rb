class AddGroupIdToAdminUser < ActiveRecord::Migration
  def change
  add_column :admin_users, :group_id, :integer
  end
end
