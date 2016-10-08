class Package < ActiveRecord::Base
mount_uploader :image, ImageUploader
validates :title, :amount, presence: true
end
