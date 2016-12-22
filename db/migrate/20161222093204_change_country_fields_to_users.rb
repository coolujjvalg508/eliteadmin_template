class ChangeCountryFieldsToUsers < ActiveRecord::Migration
  def change
	remove_column :users, :country
	remove_column :jobs, :country
	
	add_column :users, :country_id, :integer
	add_column :jobs, :country_id, :integer

  end
end
