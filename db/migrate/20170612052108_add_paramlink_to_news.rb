class AddParamlinkToNews < ActiveRecord::Migration
  def change
  	add_column :news,  :paramlink, :string
  end
end
