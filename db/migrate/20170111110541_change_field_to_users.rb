class ChangeFieldToUsers < ActiveRecord::Migration
  def change
  		remove_column :users, :skill_expertise
		remove_column :users, :software_expertise

  		add_column :users, :skill_expertise, :json
		add_column :users, :software_expertise, :json
  end
end
