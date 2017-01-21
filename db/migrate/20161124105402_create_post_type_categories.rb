class CreatePostTypeCategories < ActiveRecord::Migration
  def change
    create_table :post_type_categories do |t|
	  t.integer :post_type_id
	  t.string :name
	  t.string :image
      t.text :description
      t.string :slug
      t.integer :parent_id, index: true
      t.integer :status, default: 0
	
      t.timestamps null: false
    end
  end
end
