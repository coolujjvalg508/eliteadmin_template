class Job < ActiveRecord::Base
 mount_uploader :company_logo, ImageUploader
 #mount_uploader :image, ImageUploader
 validates :title, presence: true
 validates :paramlink, presence: true

 has_many :images, as: :imageable, dependent: :destroy
 has_many :caption_image
 
 belongs_to :company
 #belongs_to :job_category, :foreign_key =>"job_type"
 
 has_many :videos, as: :videoable, dependent: :destroy
 has_many :caption_video
 
 has_many :upload_videos, as: :uploadvideoable, dependent: :destroy
 has_many :caption_upload_video
 
 
 has_many :sketchfebs, as: :sketchfebable, dependent: :destroy
 has_many :marmo_sets, as: :marmosetable, dependent: :destroy
 
 has_many :zip_files, as: :zipfileable, dependent: :destroy
 has_many :zip_caption
 
 has_many :tags, as: :tagable, dependent: :destroy
 
 accepts_nested_attributes_for :images, reject_if: proc { |attributes| attributes['image'].blank? || attributes['image'].nil? }, allow_destroy: true 
 
 accepts_nested_attributes_for :videos, reject_if: proc { |attributes| attributes['video'].blank? || attributes['video'].nil? }, allow_destroy: true
 accepts_nested_attributes_for :upload_videos, reject_if: proc { |attributes| attributes['uploadvideo'].blank? || attributes['uploadvideo'].nil? }, allow_destroy: true
 accepts_nested_attributes_for :sketchfebs, reject_if: proc { |attributes| attributes['sketchfeb'].blank? || attributes['sketchfeb'].nil? }, allow_destroy: true
 accepts_nested_attributes_for :marmo_sets, reject_if: proc { |attributes| attributes['marmoset'].blank? || attributes['marmoset'].nil? }, allow_destroy: true
 accepts_nested_attributes_for :company,reject_if: proc { |attributes| attributes['name'].blank? || attributes['name'].nil? }, allow_destroy: true
 accepts_nested_attributes_for :zip_files, reject_if: proc { |attributes| attributes['zipfile'].blank? || attributes['zipfile'].nil? }, allow_destroy: true
 
  accepts_nested_attributes_for :tags, reject_if: proc { |attributes| attributes['tag'].blank? || attributes['tag'].nil? }, allow_destroy: true

end
