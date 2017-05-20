class AddFileInfoFieldsToZipFiles < ActiveRecord::Migration
  def change
  	add_column :zip_files, :software, :json
  	add_column :zip_files, :software_version, :json
  	add_column :zip_files, :renderer, :json
  	add_column :zip_files, :renderer_version, :json
  end
end
