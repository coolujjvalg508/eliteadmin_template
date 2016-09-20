class AddUserDetailToUsers < ActiveRecord::Migration
  def change
	add_column :users, :firstname, :string
	add_column :users, :lastname, :string
	add_column :users, :professional_headline, :string
	add_column :users, :phone_number, :string
	add_column :users, :profile_type, :string
	add_column :users, :country, :string
	add_column :users, :city, :string
	add_column :users, :image, :string
	add_column :users, :demo_reel, :string
	add_column :users, :summary, :text
	add_column :users, :available_from, :string
	add_column :users, :show_message_button, :string
	add_column :users, :interested_in, :string
	add_column :users, :skill_expertise, :string
	add_column :users, :software_expertise, :string
	add_column :users, :public_email_address, :string
	add_column :users, :website_url, :string
	add_column :users, :facebook_url, :string
	add_column :users, :linkedin_profile_url, :string
	add_column :users, :twitter_handle, :string
	add_column :users, :instagram_username, :string
	add_column :users, :behance_username, :string
	add_column :users, :tumbler_url, :string
	add_column :users, :pinterest_url, :string
	add_column :users, :youtube_url, :string
	add_column :users, :vimeo_url, :string
	add_column :users, :google_plus_url, :string
	add_column :users, :stream_profile_url, :string
  end
end
