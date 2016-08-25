class StaticPage < ActiveRecord::Base
	validates :title, :description, :page_url, presence: true
end
