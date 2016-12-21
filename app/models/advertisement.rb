class Advertisement < ActiveRecord::Base
enum status: { inactive: 0, active: 1}
 validates :title, presence: true
 
 has_many :images, as: :imageable, dependent: :destroy
 accepts_nested_attributes_for :images, reject_if: proc { |attributes| attributes['image'].blank? || attributes['image'].nil? }, allow_destroy: true 

end
