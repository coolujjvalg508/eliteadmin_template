class Topic < ActiveRecord::Base
enum status: { inactive: 0, active: 1}
mount_uploader :image, ImageUploader
validates :name, :slug, :topic_for, presence: true
end
