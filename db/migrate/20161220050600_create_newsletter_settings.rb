class CreateNewsletterSettings < ActiveRecord::Migration
  def change
    create_table :newsletter_settings do |t|
	  t.string  :email_digest_option
	  t.boolean  :en_someone_like, default: false
	  t.boolean  :en_someone_comment, default: false
	  t.boolean  :en_someone_follow, default: false
	  t.boolean  :en_im_following_post, default: false
	  t.boolean  :en_someone_comment_on_i_commented, default: false

	  t.boolean  :osn_someone_like, default: false
	  t.boolean  :osn_someone_comment, default: false
	  t.boolean  :osn_someone_follow, default: false
	  t.boolean  :osn_im_following_post, default: false
	  t.boolean  :osn_someone_comment_on_i_commented, default: false
      
      t.timestamps null: false
    end
  end
end
