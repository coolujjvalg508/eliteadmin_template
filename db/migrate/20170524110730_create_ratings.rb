class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
        t.integer :user_id
		t.string  :post_type
		t.integer :rating
		t.integer :product_id
      t.timestamps null: false
    end
  end
end
