class CreateAccessControls < ActiveRecord::Migration
  def change
    create_table :access_controls do |t|
	 t.integer  "user_group_id"
     t.text   "permissions"
      t.timestamps null: false
    end
  end
end
