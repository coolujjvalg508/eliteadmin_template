class UserPackage < ActiveRecord::Base
  mount_uploader :image, ImageUploader
	validates :title, :amount, :duration, presence: true
end
