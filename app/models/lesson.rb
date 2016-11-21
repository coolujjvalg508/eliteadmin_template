class Lesson < ActiveRecord::Base
	mount_uploader :lesson_video, VideoUploader
	mount_uploader :lesson_image, ImageUploader
	attr_accessor :tmp_lesson
end
