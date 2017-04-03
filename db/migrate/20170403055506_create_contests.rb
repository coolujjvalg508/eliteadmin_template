class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|

      t.string  :title
      t.string  :paramlink
      t.string  :schedule_time
      t.string  :is_admin
      t.text    :description
      t.integer :post_type_category_id, default: 0
      t.integer :user_id
      t.integer :medium_category_id, default: 0
      t.json 	:subject_matter_id
      t.boolean :has_adult_content, default: false
      t.json    :software_used
      t.string  :tags
      t.boolean :use_tag_from_previous_upload, default: false
      t.boolean :is_featured, default: false
      t.integer :status, default: 1
      t.integer :is_save_to_draft, default: 1
      t.integer :visibility, default: 1
      t.integer :publish, default: 1
      t.string :company_logo
      t.json    :where_to_show	
      t.json    :skill	
      t.string  :location	
      t.json    :team_member	
      t.boolean  :show_on_cgmeetup	
      t.boolean  :show_on_website	
      t.boolean  :is_spam	, default: false
      t.integer  :like_count, :default => 0
      t.integer  :comment_count, :default => 0
      t.integer  :view_count, :default => 0
      t.integer  :is_trash, :default => 0
      t.string  :zoom_w
      t.string  :zoom_h
      t.string  :zoom_x
      t.string  :zoom_y
      t.string  :drag_x
      t.string  :drag_y
      t.string  :rotation_angle
      t.string  :crop_x
      t.string  :crop_y
      t.string  :crop_w
      t.string  :crop_h
      t.json  :challenge


      t.timestamps null: false
    end
  end
end
