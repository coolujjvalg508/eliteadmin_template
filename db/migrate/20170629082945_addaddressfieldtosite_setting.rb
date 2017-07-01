class AddaddressfieldtositeSetting < ActiveRecord::Migration
  def change
  	add_column :site_settings, :address, :text
  end
end
