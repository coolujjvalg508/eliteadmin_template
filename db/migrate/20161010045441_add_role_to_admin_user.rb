class AddRoleToAdminUser < ActiveRecord::Migration
  def change
   add_column :admin_users, :role, :string, :default => 'super_admin'
  end
end
