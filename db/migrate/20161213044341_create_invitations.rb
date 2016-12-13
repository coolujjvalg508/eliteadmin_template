class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
	  t.integer :user_id, :default => 0
	  t.string :email
	  t.string :status
      t.timestamps null: false
    end
  end
end
