class Chapter < ActiveRecord::Base

    mount_uploader :image, ImageUploader


    #validates :title, presence: true
    validates :tutorial_id, presence: true
	has_many :media_contents, as: :mediacontentable, dependent: :destroy
	has_many :media_type
	has_many :video_duration
	has_many :media_caption
	has_many :media_description

    accepts_nested_attributes_for :media_contents, allow_destroy: true 

end
