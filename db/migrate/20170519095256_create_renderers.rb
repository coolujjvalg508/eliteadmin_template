class CreateRenderers < ActiveRecord::Migration
  def change
    create_table :renderers do |t|
      t.string :name
      t.text :description
      t.string :image
      t.string :slug
      t.integer :parent_id, index: true
      t.integer :status, default: true	
      t.timestamps null: false
    end
  end
end
