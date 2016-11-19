class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.string :image
      t.integer :parent_id, index: true
      t.integer :status, default: 0
      
      t.timestamps null: false
    end
  end
end
