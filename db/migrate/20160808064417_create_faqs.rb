class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.text :question
      t.text :answer
      t.boolean :active, default: true, null: false
      t.integer :position

      t.timestamps null: false
    end
  end
end
