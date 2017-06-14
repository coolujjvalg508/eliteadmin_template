class TransactionHistory < ActiveRecord::Base

	belongs_to :user
	has_many :purchased_products
	has_many :purchased_tutorials

end
