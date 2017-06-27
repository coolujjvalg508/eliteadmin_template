class CreateNewsletterSubscribers < ActiveRecord::Migration
  def change
    create_table :newsletter_subscribers do |t|
      t.string  :email
      t.timestamps null: false
    end
  end
end
