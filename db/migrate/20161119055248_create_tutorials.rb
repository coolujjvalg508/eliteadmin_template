class CreateTutorials < ActiveRecord::Migration
  def change
    create_table :tutorials do |t|
	  t.string  :title
      t.text    :description
      t.json    :topic
      t.json    :software_used
      t.integer :is_paid, default: 0
	  t.float	:price
	  t.string  :tags
      t.integer :is_featured, default: 0
      t.integer :status, default: 1
      t.integer :is_save_to_draft, default: 1
      t.integer :visibility, default: 1
      t.integer :publish, default: 1
      t.string :company_logo
      t.string :schedule_time
      t.string  :sub_title
      t.string :skill_level
      t.string :language
      t.text :include_description
      t.integer :total_lecture, default: 0
      
      t.integer :user_id, default: 0
      t.boolean :show_on_cgmeetup, :default => true
      t.boolean :show_on_website, :default => true
 		
		
		
      t.timestamps null: false
    end
  end
end
