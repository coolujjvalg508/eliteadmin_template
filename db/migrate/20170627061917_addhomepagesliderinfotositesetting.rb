class Addhomepagesliderinfotositesetting < ActiveRecord::Migration
  def change
  	add_column :site_settings, :home_page_layout_type, :integer
  end
end
