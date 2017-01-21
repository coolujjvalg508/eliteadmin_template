class CreateZipFiles < ActiveRecord::Migration
  def change
    create_table :zip_files do |t|
		t.string :zipfile
		t.string :zip_caption
		t.integer :zipfileable_id, null: false, index: true
		t.string :zipfileable_type, null: false, index: true
      t.timestamps null: false
    end
  end
end
