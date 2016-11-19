class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
		t.string :lesson_title
		t.string :lesson_video
		t.string :lesson_video_link
        t.integer :lessonable_id, null: false, index: true
		t.string :lessonable_type, null: false, index: true
		t.timestamps null: false
    end
  end
end
