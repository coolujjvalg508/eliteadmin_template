class AddLessonimageToLessons < ActiveRecord::Migration
  def change
	add_column :lessons, :lesson_image, :string
  end
end
