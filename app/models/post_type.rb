class PostType < ActiveRecord::Base
enum status: { inactive: 0, active: 1}
mount_uploader :image, ImageUploader
validates :type_name, :slug, presence: true

has_many :tags, as: :tagable, dependent: :destroy
has_many :post_type_categories, ->(post_type_category) { where("parent_id IS NULL") }

accepts_nested_attributes_for :tags, reject_if: proc { |attributes| attributes['tag'].blank? || attributes['tag'].nil? }, allow_destroy: true
end
