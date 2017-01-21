class RemoveGroupIdToUser < ActiveRecord::Migration
  def change
   remove_column :users, :group_id
  end
end
