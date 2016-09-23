class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.string  :title
      t.text    :description
      t.integer :post_type_category_id, default: 0
      t.integer :medium_category_id, default: 0
      t.json 	:subject_matter_id
      t.integer :has_adult_content
      t.json    :software_used
      t.string  :tags
      t.integer :use_tag_from_previous_upload, default: 0
      t.integer :is_featured, default: 0
      t.integer :status, default: 1
      t.integer :is_save_to_draft, default: 1
      t.integer :visibility, default: 1
      t.integer :publish, default: 1
      t.string :company_logo
      t.json    :where_to_show
      

      t.timestamps null: false
    end
  end
end
