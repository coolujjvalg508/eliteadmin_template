class NewsContent < ActiveRecord::Base

    default_scope { order(id: :ASC) }

    #validates :title, presence: true
    validates :news_id, presence: true
	has_many :media_contents, as: :mediacontentable, dependent: :destroy
	has_many :media_type
	has_many :media_caption
	has_many :media_description
	accepts_nested_attributes_for :media_contents, allow_destroy: true 

end
