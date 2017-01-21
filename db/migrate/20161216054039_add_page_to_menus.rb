class AddPageToMenus < ActiveRecord::Migration
  def change
		add_column :menus, :pagename, :string	
		add_column :menus, :menulocation, :string
  end
end
