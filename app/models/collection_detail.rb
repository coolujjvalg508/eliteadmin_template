class CollectionDetail < ActiveRecord::Base
		belongs_to :gallery, :foreign_key =>"gallery_id"
		belongs_to :download, :foreign_key =>"download_id"
		belongs_to :collection, :foreign_key =>"collection_id"
end
