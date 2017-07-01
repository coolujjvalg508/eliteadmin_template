class Addfieldtowidgets < ActiveRecord::Migration
  def change
  	add_column :widgets, :show_on_galleries_page, :boolean
  end
end
