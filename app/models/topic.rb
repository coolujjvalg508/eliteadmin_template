class Topic < ActiveRecord::Base
enum status: { inactive: 0, active: 1}
scope :active, -> { where(status: 1) }
mount_uploader :image, ImageUploader
validates :name, :slug, presence: true

has_many :tags, as: :tagable, dependent: :destroy
has_many :tutorial_subjects, ->(tutorial_subjects) { where("parent_id IS NULL") }
accepts_nested_attributes_for :tags, reject_if: proc { |attributes| attributes['tag'].blank? || attributes['tag'].nil? }, allow_destroy: true
end
