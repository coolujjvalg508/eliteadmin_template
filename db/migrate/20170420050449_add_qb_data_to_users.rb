class AddQbDataToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :qb_id, :string
  	add_column :users, :qb_password, :string
  end
end
