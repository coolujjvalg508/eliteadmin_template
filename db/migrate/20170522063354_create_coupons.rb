class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
    	t.string :coupon_code, :limit => 20
		  t.integer :discount_value
	  	t.string :discount_type
		  t.date :valid_from
		  t.date :valid_till
		  t.boolean :status, null: false, default: true	
      t.integer :no_of_use
      t.string :is_admin
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
