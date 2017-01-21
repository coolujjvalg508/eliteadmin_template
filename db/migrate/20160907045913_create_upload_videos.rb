class CreateUploadVideos < ActiveRecord::Migration
  def change
    create_table :upload_videos do |t|
        t.string :uploadvideo
        t.integer :uploadvideoable_id, null: false, index: true
		t.string :uploadvideoable_type, null: false, index: true
		t.timestamps null: false

    end
  end
end
