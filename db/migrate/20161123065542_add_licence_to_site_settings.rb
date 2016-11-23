class AddLicenceToSiteSettings < ActiveRecord::Migration
  def change
	add_column :site_settings, :licence, :text
  end
end
