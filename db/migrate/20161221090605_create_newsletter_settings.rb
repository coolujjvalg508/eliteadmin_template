class CreateNewsletterSettings < ActiveRecord::Migration
  def change
    create_table :newsletter_settings do |t|
      t.string   :email_digest_option
      t.boolean  :job_email, default: false
      t.boolean  :gallery_email, default: false
      t.boolean  :download_email, default: false
      t.boolean  :tutorial_email, default: false
      t.boolean  :news_email, default: false
     
      t.timestamps null: false
    end
  end
end
