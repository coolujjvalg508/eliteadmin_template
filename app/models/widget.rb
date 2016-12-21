class Widget < ActiveRecord::Base
 validates :title,:widgetcode,:sectionname, presence: true
end
