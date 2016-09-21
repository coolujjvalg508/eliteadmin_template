class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string  :title
      t.string  :paramlink
      t.text    :description
      t.string   :company_name
      t.integer  :job_type, default: 0
      t.string   :from_amount
      t.string   :to_amount
      t.string   :job_category
      t.string   :application_email_or_url
      t.string   :country
      t.string   :city
      t.integer   :work_remotely, default: 1
      t.integer   :relocation_asistance, default: 1
      t.string    :closing_date
      t.json    :skill
      t.json    :software_expertise
      t.string  :tags
      t.integer :use_tag_from_previous_upload, default: 0
      t.integer :is_featured, default: 0
      t.integer :status, default: 1
      t.integer :is_save_to_draft, default: 1
      t.integer :visibility, default: 1
      t.integer :publish, default: 1
      t.string  :company_logo
      t.json :where_to_show

      
      

      t.timestamps null: false
    end
  end
end
