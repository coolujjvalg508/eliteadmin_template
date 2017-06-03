class CreateTransactionHistories < ActiveRecord::Migration
  def change
    create_table :transaction_histories do |t|
      t.integer :user_id, default: 0
      t.string   :payment_method	
	  t.string :txn_id
	  t.string :payer_id	
	  t.float :gross_amount	
	  t.float :discount_amount	
	  t.float :net_amount	
	  t.string :coupon_code	
	  t.boolean :is_company, :default => false	
	  t.string :company_name	
	  t.string :company_code	
	  t.string :company_vat	
	  t.string :company_country	
	  t.string :company_city	
	  t.string :company_address	
	  t.text   :response
      t.timestamps null: false
    end
  end
end
