class AddFileFormatIdToDownloads < ActiveRecord::Migration
  def change
  	add_column :downloads, :file_format_id, :integer
  end
end
