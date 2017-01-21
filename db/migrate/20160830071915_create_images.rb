class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
     t.string :image
      t.integer :imageable_id, null: false, index: true
			t.string :imageable_type, null: false, index: true


      t.timestamps null: false
    end
  end
end
