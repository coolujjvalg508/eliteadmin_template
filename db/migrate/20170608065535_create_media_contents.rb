class CreateMediaContents < ActiveRecord::Migration
  def change
    create_table :media_contents do |t|
      t.string  :mediacontent
      t.integer :mediacontentable_id, null: false, index: true
	  t.string :mediacontentable_type, null: false, index: true
	  t.string :media_type
	  t.string :video_duration
	  t.string :media_caption
	  t.text   :media_description
	  t.timestamps null: false
    end
  end
end
