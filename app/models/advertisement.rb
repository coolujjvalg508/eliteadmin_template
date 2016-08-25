class Advertisement < ActiveRecord::Base
enum status: { inactive: 0, active: 1}
mount_uploader :image, ImageUploader
validates :title, :image, presence: true
end
