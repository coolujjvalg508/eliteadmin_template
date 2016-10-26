ActiveAdmin.register MainSidebar do

	menu label: 'Main Sidebar', parent: 'Widget',priority: 2 
	permit_params :description, :dp_title, :dp_number, :dp_style, :cat_title, :cat_display_as_dropdown, :cat_show_post_count, :cat_show_hierarchy, :open_link_in_new_window, :show_button, :fb_page_name, :fb_default, :fb_position, :tw_username, :tw_default, :tw_position, :youtube_channel, :youtube_default, :youtube_position, :viemo_channel, :viemo_default, :viemo_position, :feedburner_feedname, :feedburner_default, :feedburner_position, :dribbble_username, :dribbble_default, :dribbble_position, :forrst_username, :forrst_default, :forrst_position, :digg_username, :digg_default, :digg_position
	actions :all, except: [:destroy, :new, :create]

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
			
		f.inputs "Main Sidebar" do
			  f.input :description
			  f.inputs 'DP Related Posts Widget' do
					  f.input :dp_title,label:'Title'
					  f.input :dp_number,label:'Number'
					  f.input :dp_style, as: :select, collection: MainSidebar::DPSTYLES, label:'Style', include_blank: false
			  end	
			  f.inputs 'Categories' do
					  f.input :cat_title,label:'Title'
					  f.input :cat_display_as_dropdown,label:'Display as dropdown'
					  f.input :cat_show_post_count,label:'Show post counts'
					  f.input :cat_show_hierarchy,label:'Show hierarchy'
					  
			 end	
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
					  
					  f.input :youtube_channel,label:'Youtube channel'
					  f.input :youtube_default,label:'Youtube Default'
					  f.input :youtube_position,label:'Youtube Position'
					  
					   
					  li do  end
					  
					  f.input :viemo_channel,label:'Vimeo channel'
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
