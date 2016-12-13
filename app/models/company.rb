class Company < ActiveRecord::Base
 has_one :job
  validates :name,:email, presence: true
  validates :name,:email, uniqueness: true
end
