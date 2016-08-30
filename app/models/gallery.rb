class Gallery < ActiveRecord::Base
 mount_uploader :company_logo, ImageUploader
 validates :title, presence: true
 has_many :image, as: :imageable, dependent: :destroy
 accepts_nested_attributes_for :image
end
