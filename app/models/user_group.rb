class UserGroup < ActiveRecord::Base
validates :name, presence: true
end
