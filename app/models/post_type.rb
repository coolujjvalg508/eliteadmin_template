class PostType < ActiveRecord::Base
enum status: { inactive: 0, active: 1}
mount_uploader :image, ImageUploader
validates :type_name, :slug, presence: true
end
