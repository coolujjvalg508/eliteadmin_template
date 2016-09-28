class Company < ActiveRecord::Base
 has_one :job
 # validates :name, presence: true
 # validates :name, uniqueness: true
end
