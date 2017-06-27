class AddisurgentFieldsTotables < ActiveRecord::Migration
  def change

  	#add_column :jobs, :is_urgent, :boolean, :default => false
  	add_column :news, :is_urgent, :boolean, :default => false
  end
end
