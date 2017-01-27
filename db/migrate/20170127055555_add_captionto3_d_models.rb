class AddCaptionto3DModels < ActiveRecord::Migration
  def change
  	add_column :marmo_sets, :caption_marmoset, :string
  	add_column :sketchfebs, :caption_sketchfeb, :string
  end
end
