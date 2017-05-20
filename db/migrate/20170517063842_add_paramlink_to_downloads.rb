class AddParamlinkToDownloads < ActiveRecord::Migration
  def change
  	add_column :downloads, :paramlink, :string
  	add_column :downloads, :product_id, :string
  end
end
