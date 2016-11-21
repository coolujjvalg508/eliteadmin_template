class AddLessonDescriptionToLessons < ActiveRecord::Migration
  def change
  add_column :lessons, :lesson_description, :text
  end
end
