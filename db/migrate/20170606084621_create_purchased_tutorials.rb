class CreatePurchasedTutorials < ActiveRecord::Migration
  def change
    create_table :purchased_tutorials do |t|
  	  t.integer :user_id
      t.integer :tutorial_id
      t.integer :transaction_history_id
      t.float 	:price, :default => 0.0
      t.timestamps null: false
    end
  end
end
