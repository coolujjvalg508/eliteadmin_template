class AddUserIdToTables < ActiveRecord::Migration
  def change
   add_column :galleries, :user_id, :integer
   add_column :jobs, :user_id, :integer
  end
end
