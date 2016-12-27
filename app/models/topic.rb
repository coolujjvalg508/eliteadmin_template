class Topic < ActiveRecord::Base
enum status: { inactive: 0, active: 1}
scope :active, -> { where(status: 1) }
mount_uploader :image, ImageUploader
validates :name, :slug, presence: true
end
