class CreateContestFollows < ActiveRecord::Migration
  def change
    create_table :contest_follows do |t|
	 	t.integer :user_id, default: 0
		t.integer :contest_id, default: 0
		t.string :post_type
	    t.timestamps null: false
    end
  end
end
