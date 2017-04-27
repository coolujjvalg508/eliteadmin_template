class CreateBlockUsers < ActiveRecord::Migration
  def change
    create_table :block_users do |t|
    	t.integer  :user_id
    	t.json  :block_user_id
      t.timestamps null: false
    end
  end
end
