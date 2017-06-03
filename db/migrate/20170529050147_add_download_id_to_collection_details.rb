class AddDownloadIdToCollectionDetails < ActiveRecord::Migration
  def change
  	add_column :collection_details, :download_id, :integer, :default => 0
  	add_column :collections, :download_id, :integer, :default => 0
  end
end
