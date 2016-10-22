ActiveAdmin.register HomeSidebar do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


	menu label: 'Home Sidebar', parent: 'Widget',priority: 3
	
	permit_params :description, :open_link_in_new_window, :show_button, :fb_page_name, :fb_default, :fb_position, :tw_username, :tw_default, :tw_position, :youtube_channel, :youtube_default, :youtube_position, :viemo_channel, :viemo_default, :viemo_position, :feedburner_feedname, :feedburner_default, :feedburner_position, :dribbble_username, :dribbble_default, :dribbble_position, :forrst_username, :forrst_default, :forrst_position, :digg_username, :digg_default, :digg_position, :custom_menu_title ,:dp_title, :dp_number, :dp_order_by, :dp_order, :dp_category, :limit_post_by_current_category, :limit_post_by_current_author, :dp_includes, :dp_style, :cat_title, :cat_display_as_dropdown, :cat_show_post_count, :cat_show_hierarchy, :rss_url,:give_feed, :number_of_display_item, :display_item_content, :display_item_author, :display_item_date
	
	#actions :all, except: [:destroy, :new, :create]
	
	 controller do 
		def action_methods
		 super                                    
			if current_admin_user.id.to_s == '1'
			super
		  else
			usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
			disallowed = []
			disallowed << 'index' if (!usergroup.has_permission('widget_read') && !usergroup.has_permission('widget_write') && !usergroup.has_permission('widget_delete'))
			disallowed << 'delete' unless (usergroup.has_permission('widget_delete'))
			disallowed << 'create' unless (usergroup.has_permission('widget_write'))
			disallowed << 'new' unless (usergroup.has_permission('widget_write'))
			disallowed << 'edit' unless (usergroup.has_permission('widget_write'))
			disallowed << 'destroy' unless (usergroup.has_permission('widget_delete'))
			
			super - disallowed
		  end
		end
	  end
	
	
	
	
	
	
	form multipart: true do |f|
			
		f.inputs "Home Sidebar" do
			  f.input :description
			  
			   f.inputs 'Social box' do
					  f.input :open_link_in_new_window,label:'Open Links in new Window/Tab'
					  f.input :show_button,label:'Show Buttons'
					 
					  f.input :fb_page_name,label:'Facebook Page ID/Name'
					  f.input :fb_default,label:'Facebook Default'
					  f.input :fb_position,label:'Facebook Position'
					  
					  li do  end
					  
					  f.input :tw_username,label:'Twitter Username'
					  f.input :tw_default,label:'Twitter Default'
					  f.input :tw_position,label:'Twitter Position'
					  
					  li do  end
					  
					  f.input :youtube_channel,label:'Youtube Channel'
					  f.input :youtube_default,label:'Youtube Default'
					  f.input :youtube_position,label:'Youtube Position'
					  
					   
					  li do  end
					  
					  f.input :viemo_channel,label:'Vimeo Channel'
					  f.input :viemo_default,label:'Vimeo Default'
					  f.input :viemo_position,label:'Vimeo Position'
					  
					  li do  end
					  
					  f.input :feedburner_feedname,label:'Feedburner Feedname'
					  f.input :feedburner_default,label:'Feedburner Default'
					  f.input :feedburner_position,label:'Feedburner Position'
					  
					  
					  li do  end
					  
					  f.input :dribbble_username,label:'Dribbble Username'
					  f.input :dribbble_default,label:'Dribbble Default'
					  f.input :dribbble_position,label:'Dribbble Position'
					  
					  li do  end
					  
					  f.input :forrst_username,label:'Forrst Username'
					  f.input :forrst_default,label:'Forrst Default'
					  f.input :forrst_position,label:'Forrst Position'
					  
					  li do  end
					  
					  f.input :digg_username,label:'Digg Username'
					  f.input :digg_default,label:'Digg Default'
					  f.input :digg_position,label:'Digg Position'
					  
					  
			 end	
			  f.inputs 'Custom Menu' do
					  f.input :custom_menu_title,label:'Title'
			  end	
			  f.inputs 'DP Related Posts Widget' do
					  f.input :dp_title,label:'Title'
					  f.input :dp_number,label:'Number'
					  f.input :dp_order_by,label:'Order By', as: :select, collection: HomeSidebar::ORDERBY, include_blank: false
					  f.input :dp_order,label:'Order', as: :select, collection: HomeSidebar::ORDER, include_blank: false
					  f.input :dp_category,label:'Category', as: :select, collection: HomeSidebar::CATEGORY, include_blank: false
					  f.input :limit_post_by_current_category,label:'Limit posts by current category on category archive pages?'
					  f.input :limit_post_by_current_author,label:'Limit posts by current author on author archive pages?'
					  f.input :dp_includes,label:'Includes'
					  f.input :dp_style,label:'Style', as: :select, collection: HomeSidebar::DPSTYLES, include_blank: false
					  
			  end	
			   f.inputs 'Rss: Job Updates' do
					  f.input :rss_url,label:'Rss Feed Url'
					  f.input :give_feed,label:'Give the Feed a title'
					  f.input :number_of_display_item,label:'Number of Display Item'
					  f.input :display_item_content,label:'Display item content?'
					  f.input :display_item_author,label:'Display item author if available?'
					  f.input :display_item_date,label:'Display item date?'
					 
					  
			  end	
			  f.inputs 'Categories' do
					  f.input :cat_title,label:'Title'
					  f.input :cat_display_as_dropdown,label:'Display as dropdown'
					  f.input :cat_show_post_count,label:'Show post counts'
					  f.input :cat_show_hierarchy,label:'Show hierarchy'
					  
			 end	
			
	    end
		
		f.actions
	end
	
	 index :download_links => ['csv'] do
		selectable_column
		column :description do |cat|
			tr_con = cat.description.first(50)
		end
		column :created_at
		actions 
	  end

	
  filter :description
  filter :created_at
	
	
end
