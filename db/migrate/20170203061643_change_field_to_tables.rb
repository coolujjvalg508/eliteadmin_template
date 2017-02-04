class ChangeFieldToTables < ActiveRecord::Migration
  def change
    	remove_column :tutorials, :challenge
    	remove_column :galleries, :challenge
    	remove_column :downloads, :challenge
		

  		add_column :tutorials, :challenge, :json
		add_column :galleries, :challenge, :json
		add_column :downloads, :challenge, :json
  end
end
