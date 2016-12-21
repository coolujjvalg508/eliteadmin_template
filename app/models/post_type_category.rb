class PostTypeCategory < ActiveRecord::Base

enum status: { inactive: 0, active: 1}
mount_uploader :image, ImageUploader
validates :name, :slug, :post_type_id, presence: true

end
