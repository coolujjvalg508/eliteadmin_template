class CreateCollectionDetails < ActiveRecord::Migration
  def change
    create_table :collection_details do |t|
        t.integer 	:gallery_id, default: 0
		t.integer   :collection_id , default: 0
        t.timestamps null: false
    end
  end
end
