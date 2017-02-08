class CreatePostLikes < ActiveRecord::Migration
  def change
    create_table :post_likes do |t|
      t.integer :user_id, default: 0
	  t.integer :post_id, default: 0
	  t.string :post_type
      t.timestamps null: false
    end
  end
end
