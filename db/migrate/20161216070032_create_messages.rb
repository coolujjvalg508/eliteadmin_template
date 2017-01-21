class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
	  t.integer  :sender_id
	  t.integer  :receiver_id
	  t.text  :message
	  t.boolean  :is_read, :default => false
	  t.boolean  :is_admin, :default => false
	  t.timestamps null: false
    end
  end
end
