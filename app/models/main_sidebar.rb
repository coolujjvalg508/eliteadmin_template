class MainSidebar < ActiveRecord::Base
	validates :description, presence: true
	DPSTYLES = [['List With Thumbnail',1], ['List With Full width Thumbnail', 2], ['2 Columns Grid', 3], ['3 Columns Grid', 4]]
end
