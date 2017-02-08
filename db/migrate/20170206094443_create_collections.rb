class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string  :title
      t.integer :gallery_id, default: 0	
      t.timestamps null: false
    end
  end
end
