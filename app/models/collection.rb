class Collection < ActiveRecord::Base
	 validates :title, presence: true
	 validates :title, uniqueness: {message: 'Title has already taken.'}
     
     belongs_to :gallery, :foreign_key =>"gallery_id"
     belongs_to :download, :foreign_key =>"download_id"
     has_many :collection_detail
end
