class Lesson < ActiveRecord::Base
	mount_uploader :lesson_video, VideoUploader
	mount_uploader :lesson_image, ImageUploader
	attr_accessor :tmp_lesson

	has_many :media_contents, as: :mediacontentable, dependent: :destroy
	has_many :media_type
	has_many :video_duration
	has_many :media_caption
	has_many :description


  accepts_nested_attributes_for :media_contents, allow_destroy: true 

end
