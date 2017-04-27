class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
    	t.integer  :user_id
    	t.boolean  :emailnotify_like_myartwork, :default => false
    	t.boolean  :emailnotify_comment_myartwork, :default => false
    	t.boolean  :emailnotify_followme, :default => false
    	t.boolean  :emailnotify_like_mycomment, :default => false
    	t.boolean  :emailnotify_following_user_newartwork, :default => false
    	t.boolean  :emailnotify_comment_on_mycommentedpost, :default => false
    	t.boolean  :emailnotify_reply_on_mycomment, :default => false
    	t.boolean  :emailnotify_subcribed_challengesubmission, :default => false
    	t.boolean  :emailnotify_like_mysubmission, :default => false
    	t.boolean  :emailnotify_like_mysubmissionupdate, :default => false
    	t.boolean  :emailnotify_challenge_announcements, :default => false
    	t.boolean  :emailnotify_newreply_on_challengeannouncement, :default => false
    	t.boolean  :emailnotify_newreply_on_challengesubmissionupdate, :default => false
    	t.boolean  :emailnotify_like_repliestodiscussion, :default => false
    	t.boolean  :emailnotify_like_postedchallengeannouncement, :default => false
    	t.boolean  :notifyme_like_myartwork, :default => false
    	t.boolean  :notifyme_comment_myartwork, :default => false
    	t.boolean  :notifyme_followme, :default => false
    	t.boolean  :notifyme_like_mycomment, :default => false
    	t.boolean  :notifyme_following_user_newartwork, :default => false
    	t.boolean  :notifyme_comment_on_mycommentedpost, :default => false
    	t.boolean  :notifyme_reply_on_mycomment, :default => false
    	t.boolean  :notifyme_subcribed_challengesubmission, :default => false
    	t.boolean  :notifyme_like_mysubmission, :default => false
    	t.boolean  :notifyme_like_mysubmissionupdate, :default => false
    	t.boolean  :notifyme_challenge_announcements, :default => false
    	t.boolean  :notifyme_newreply_on_challengeannouncement, :default => false
    	t.boolean  :notifyme_newreply_on_challengesubmissionupdate, :default => false
    	t.boolean  :notifyme_like_repliestodiscussion, :default => false
    	t.boolean  :notifyme_like_postedchallengeannouncement, :default => false
    	t.boolean  :emailnotify_announcement_subscription, :default => false
    	t.boolean  :emailnotify_newjob_jobdigest_subscription, :default => false
    	t.boolean  :emailnotify_newtutorials_jobdigest_subscription, :default => false
    	t.boolean  :emailnotify_newdownloads_jobdigest_subscription, :default => false
      t.timestamps null: false
    end
  end
end
