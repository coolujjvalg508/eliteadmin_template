class CategoryType < ActiveRecord::Base
mount_uploader :image, ImageUploader
validates :name, :slug, presence: true
end
