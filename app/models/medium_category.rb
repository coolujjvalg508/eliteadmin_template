class MediumCategory < ActiveRecord::Base
enum status: { inactive: 0, active: 1}
mount_uploader :image, ImageUploader
validates :name, :slug, presence: true
end
