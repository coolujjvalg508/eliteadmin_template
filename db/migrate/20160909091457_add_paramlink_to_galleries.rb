class AddParamlinkToGalleries < ActiveRecord::Migration
  def change
   add_column :galleries, :paramlink, :string
  end
end
