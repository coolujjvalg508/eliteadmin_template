class Tag < ActiveRecord::Base
 validates :title, presence: true
 validates :tags, presence: true
end
