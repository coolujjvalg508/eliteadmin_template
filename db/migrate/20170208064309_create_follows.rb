class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
 		t.integer :user_id, default: 0
		t.integer :artist_id, default: 0
	 	t.string :post_type
     	t.timestamps null: false
    end
  end
end
