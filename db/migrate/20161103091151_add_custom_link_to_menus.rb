class AddCustomLinkToMenus < ActiveRecord::Migration
  def change
	add_column :menus, :is_custom_link, :boolean, :default => false
  end
end
