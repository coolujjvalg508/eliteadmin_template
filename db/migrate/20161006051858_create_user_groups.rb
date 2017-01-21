class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
	  t.string   :name
	  t.boolean  :can_access_acp, default: true
	  t.boolean  :is_super_mod, default: true
      t.timestamps null: false
    end
  end
end
