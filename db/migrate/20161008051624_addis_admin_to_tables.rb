class AddisAdminToTables < ActiveRecord::Migration
  def change
   add_column :galleries, :is_admin, :string
   add_column :jobs, :is_admin, :string
  end
end
