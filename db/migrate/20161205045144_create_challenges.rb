class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
		  t.string  :title
		  t.text    :description
		  t.string  :upload_button_text
		  t.integer :challenge_type_id, default: 0
		  t.string :closing_date
		  t.string  :tags
		  t.text    :awards
		  t.text    :terms_condition
		  t.text    :judging
		  t.text    :faq
		  t.integer :status, default: 1
		  t.integer :is_save_to_draft, default: 1
		  t.integer :visibility, default: 1
		  t.integer :publish, default: 1
		  t.string :company_logo
		  t.string :schedule_time
		  t.json    :where_to_show
		  t.integer :user_id, default: 0
		  t.string :is_admin
		  


		  t.timestamps null: false
    end
  end
end
