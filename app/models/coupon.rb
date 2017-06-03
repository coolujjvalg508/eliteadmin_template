class Coupon < ActiveRecord::Base

	scope :active, -> { where(status: true) }

	DISCOUNT_TYPE = ['Percent', 'Amount']
    

	validates :coupon_code, presence: {message: "Coupan code can't be blank"}
	validates :coupon_code, uniqueness: {message: 'Coupon code is already exist'}
	validates :discount_value, presence: {message: "Discount value can't be blank"}
	validates :discount_type, presence: {message: "Please select Discount type"}
	validates :valid_from, presence: {message: "Valid From date Required"}
	validates :valid_till, presence: {message: "Valid Till date Required"}
	validates :no_of_use, presence: {message: "No of time usable Required"}
end
