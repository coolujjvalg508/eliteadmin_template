class AddFieldsToDownloads < ActiveRecord::Migration
  def change
  add_column :downloads, :animated, :boolean, :default => false
  add_column :downloads, :rigged, :boolean, :default => false
  add_column :downloads, :lowpoly, :boolean, :default => true
  add_column :downloads, :texture, :boolean, :default => false
  add_column :downloads, :material, :boolean, :default => false
  add_column :downloads, :uv_mapping, :boolean, :default => false
  add_column :downloads, :plugin_used , :boolean, :default => false
  add_column :downloads, :unwrapped_uv , :string
  add_column :downloads, :polygon , :string
  add_column :downloads, :vertice , :string
  add_column :downloads, :geometry , :string
  add_column :downloads, :user_title , :string
  end
end
