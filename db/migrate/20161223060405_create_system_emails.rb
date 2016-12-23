class CreateSystemEmails < ActiveRecord::Migration
  def change
    create_table :system_emails do |t|
	  t.string :title
      t.string :subject
      t.text :content
      t.text :footer
      t.integer :status

      t.timestamps null: false
    end
  end
end
