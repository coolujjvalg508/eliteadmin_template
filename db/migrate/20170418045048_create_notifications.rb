class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|

      t.integer :user_id, default: 0
  	  t.integer :post_id, default: 0
  	  t.integer :artist_id, default: 0	  
      t.string :notification_type
  	  t.string :section_type
  	  t.integer :is_read, default: 0	  
      t.timestamps null: false 	
    end
  end
end
