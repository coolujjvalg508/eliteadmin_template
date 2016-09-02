class Gallery < ActiveRecord::Base
 mount_uploader :company_logo, ImageUploader
 #mount_uploader :image, ImageUploader
 
 validates :title, presence: true
 
 has_many :images, as: :imageable, dependent: :destroy
 has_many :videos, as: :videoable, dependent: :destroy
 accepts_nested_attributes_for :images, reject_if: proc { |attributes| attributes['image'].blank? || attributes['image'].nil? }, allow_destroy: true
 accepts_nested_attributes_for :videos, reject_if: proc { |attributes| attributes['video'].blank? || attributes['video'].nil? }, allow_destroy: true


end
