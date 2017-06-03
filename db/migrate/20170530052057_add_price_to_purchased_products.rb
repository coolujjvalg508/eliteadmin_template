class AddPriceToPurchasedProducts < ActiveRecord::Migration
  def change
  	add_column :purchased_products, :price, :float, :default => 0.0
  end
end
