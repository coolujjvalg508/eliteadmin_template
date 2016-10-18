class Menu < ActiveRecord::Base
 validates :title, presence: true
 validates :navigation_label, presence: true

end
