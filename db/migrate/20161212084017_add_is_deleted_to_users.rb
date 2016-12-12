class AddIsDeletedToUsers < ActiveRecord::Migration
  def change
  add_column :users, :is_deleted, :integer, :default => 0
  end
end
