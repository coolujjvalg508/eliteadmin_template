class Lesson < ActiveRecord::Base
	mount_uploader :lesson_video, VideoUploader
	attr_accessor :tmp_lesson
end
