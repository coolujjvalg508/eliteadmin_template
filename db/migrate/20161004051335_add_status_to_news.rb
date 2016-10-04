class AddStatusToNews < ActiveRecord::Migration
  def change
	  add_column :news, :status, :boolean, :default => true
  end
end
