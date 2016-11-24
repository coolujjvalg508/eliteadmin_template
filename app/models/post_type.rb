class PostType < ActiveRecord::Base
validates :type_name, presence: true
end
