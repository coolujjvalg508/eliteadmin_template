class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.string :title
      t.text :description
      t.string :image
      t.integer :status, default: 1
      
      t.timestamps null: false
    end
  end
end
