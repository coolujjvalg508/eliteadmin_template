class HomeSidebar < ActiveRecord::Base
	validates :description, presence: true
	
	ORDERBY = [['Date',1], ['Title', 2], ['View', 3], ['Likes', 4], ['Comments', 5], ['None', 6]]
	ORDER = [['Decending',1], ['Ascending', 2]]
	CATEGORY = [['All',1], ['Uncategorized', 2], ['Architecture', 3], ['Animals', 4], ['Birds', 5], ['Fish', 6], ['Insects', 7], ['Mammals', 8], ['Reptiles & Amphibians', 9], ['Anatomy', 10], ['Body parts', 11]]
	DPSTYLES = [['List With Thumbnail',1], ['List With Full width Thumbnail', 2], ['2 Columns Grid', 3], ['3 Columns Grid', 4]]
end
