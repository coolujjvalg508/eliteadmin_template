class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
        t.string :video
        t.integer :videoable_id, null: false, index: true
		t.string :videoable_type, null: false, index: true
		t.timestamps null: false
    end
  end
end
