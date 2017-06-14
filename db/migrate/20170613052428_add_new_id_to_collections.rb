class AddNewIdToCollections < ActiveRecord::Migration
  def change
  	add_column :collection_details, :tutorial_id, :integer, :default => 0
  	add_column :collections, :tutorial_id, :integer, :default => 0
  	add_column :collection_details, :news_id, :integer, :default => 0
  	add_column :collections, :news_id, :integer, :default => 0
  end
end
