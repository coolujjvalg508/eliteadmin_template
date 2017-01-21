class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
		t.string :tag
        t.integer :tagable_id, null: false, index: true
		t.string :tagable_type, null: false, index: true
		t.timestamps null: false
    end
  end
end
