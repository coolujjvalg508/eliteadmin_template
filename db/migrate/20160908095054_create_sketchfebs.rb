class CreateSketchfebs < ActiveRecord::Migration
  def change
    create_table :sketchfebs do |t|
       t.string :sketchfeb
        t.integer :sketchfebable_id, null: false, index: true
		t.string :sketchfebable_type, null: false, index: true
		t.timestamps null: false
    end
  end
end
