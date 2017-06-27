class Addsettingfieldstosetting < ActiveRecord::Migration
  def change
  	add_column :site_settings, :show_news, :boolean, :default => true
  	add_column :site_settings, :show_community, :boolean, :default => true
  	add_column :site_settings, :show_behind_the_scenes, :boolean, :default => true
  	add_column :site_settings, :show_tutorials, :boolean, :default => true
  	add_column :site_settings, :show_news_press_release, :boolean, :default => true
  	add_column :site_settings, :show_movies_film_trailor, :boolean, :default => true
  	add_column :site_settings, :show_job_updates, :boolean, :default => true
  	add_column :site_settings, :show_downloads, :boolean, :default => true
  	add_column :site_settings, :show_latest_post, :boolean, :default => true
  	add_column :site_settings, :show_top_artists, :boolean, :default => true
  	add_column :site_settings, :show_top_categories, :boolean, :default => true
  	add_column :site_settings, :facebook_link, :string
  	add_column :site_settings, :facebook_like_count, :string
  	add_column :site_settings, :twitter_link, :string
  	add_column :site_settings, :twitter_like_count, :string
  	add_column :site_settings, :google_plus_link, :string
  	add_column :site_settings, :google_plus_like_count, :string
  	add_column :site_settings, :youtube_link, :string
  	add_column :site_settings, :youtube_like_count, :string
  	add_column :site_settings, :instagram_link, :string
  	add_column :site_settings, :instagram_like_count, :string
  end
end
