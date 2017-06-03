class PurchasedProduct < ActiveRecord::Base

	belongs_to :user
	belongs_to :download
	belongs_to :transaction_history, :class_name => "TransactionHistory", :foreign_key => "transaction_history_id"

end
