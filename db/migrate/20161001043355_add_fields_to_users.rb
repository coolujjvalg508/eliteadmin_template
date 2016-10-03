class AddFieldsToUsers < ActiveRecord::Migration
  def change
  add_column :users, :full_time_employment, :boolean
  add_column :users, :contract, :boolean
  add_column :users, :freelance, :boolean
  end
end
