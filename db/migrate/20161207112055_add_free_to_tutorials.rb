class AddFreeToTutorials < ActiveRecord::Migration
  def change
	add_column :tutorials, :free, :boolean, :default => false
  end
end
