class CreateHomeSidebars < ActiveRecord::Migration
  def change
    create_table :home_sidebars do |t|
    
		  t.text       :description
		  
		  t.boolean    :open_link_in_new_window, default: true
		  t.boolean    :show_button, default: true
		 
		  t.string     :fb_page_name
		  t.string     :fb_default
		  t.string     :fb_position
		  
		  t.string     :tw_username
		  t.string     :tw_default
		  t.string     :tw_position
		  
		  t.string     :youtube_channel
		  t.string     :youtube_default
		  t.string     :youtube_position
		  
		  t.string     :viemo_channel
		  t.string     :viemo_default
		  t.string     :viemo_position
		  
		  t.string     :feedburner_feedname
		  t.string     :feedburner_default
		  t.string     :feedburner_position
		  
		  
		  t.string     :dribbble_username
		  t.string     :dribbble_default
		  t.string     :dribbble_position
		  
		  
		  t.string     :forrst_username
		  t.string     :forrst_default
		  t.string     :forrst_position
		  
		  
		  t.string     :digg_username
		  t.string     :digg_default
		  t.string     :digg_position
		
		  t.string     :custom_menu_title
		 
		  t.string     :dp_title
		  t.integer    :dp_number
		  t.integer    :dp_order_by
		  t.string     :dp_order
		  t.integer    :dp_category
		  t.boolean    :limit_post_by_current_category, default: true
		  t.boolean    :limit_post_by_current_author, default: true
		  t.string     :dp_includes
		  t.string     :dp_style
		  
		 
		  
		  
		  t.string     :rss_url
		  t.string     :give_feed
		  t.integer    :number_of_display_item
		  
		  t.boolean    :display_item_content, default: true
		  t.boolean    :display_item_author, default: false
		  t.boolean    :display_item_date, default: false
		  
		  t.string     :cat_title
		  t.boolean    :cat_display_as_dropdown, default: true
		  t.boolean    :cat_show_post_count, default: false
		  t.boolean    :cat_show_hierarchy, default: false
		  
		  
		  

		  t.timestamps null: false
    end
  end
end
