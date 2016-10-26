class CreatePostComments < ActiveRecord::Migration
  def change
    create_table :post_comments do |t|
    
      t.string     :title
	  t.text       :description
	  t.integer    :user_id
	  t.boolean    :is_pending, default: false
	  t.boolean    :is_approve, default: true
	  t.boolean    :is_spam, default: false
	  t.boolean    :is_trash, default: false

      t.timestamps null: false
    end
  end
end
