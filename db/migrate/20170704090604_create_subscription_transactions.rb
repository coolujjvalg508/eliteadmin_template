class CreateSubscriptionTransactions < ActiveRecord::Migration
  def change
    create_table :subscription_transactions do |t|
      t.integer :user_id, default: 0
      t.string   :payment_method	
	  t.string :txn_id
	  t.string :payer_id	
	  t.float :net_amount
	  t.boolean :is_company, :default => false	
	  t.string :first_name	
	  t.string :last_name	
	  t.string :company_name	
	  t.string :email
	  t.string :city	
	  t.string :country	
	  t.string :state	
	  t.text :response	
	  t.string :zip_code	
	  t.text   :address1
	  t.text   :address2
      t.timestamps null: false
    end
  end
end


