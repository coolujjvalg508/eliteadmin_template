class CreateMediumCategories < ActiveRecord::Migration
  def change
    create_table :medium_categories do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.integer :parent_id, index: true
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
