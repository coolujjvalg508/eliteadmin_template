class PostComment < ActiveRecord::Base
	#validates :title, presence: true
	validates :description, presence: true
	belongs_to :user
end
