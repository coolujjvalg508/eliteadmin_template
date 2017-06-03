class CreatePurchasedProducts < ActiveRecord::Migration
  def change
    create_table :purchased_products do |t|
      t.integer :user_id
      t.integer :download_id
      t.integer :transaction_history_id
      t.timestamps null: false
    end
  end
end
