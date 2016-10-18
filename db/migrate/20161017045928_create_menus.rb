class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
    
      t.string   :title
      t.integer  :parent_id, default: 0
      t.string   :url
      t.string   :navigation_label
      t.integer  :position, default: 0
      t.boolean  :status, default: true
     
        

      t.timestamps null: false
    end
  end
end
