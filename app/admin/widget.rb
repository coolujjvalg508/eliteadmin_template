ActiveAdmin.register Widget do
	menu label: 'Widget', priority: 15
	permit_params :title, :section_name, :ad_code, :position, :show_on_home_page,
								:show_on_news_page, :show_on_downloads_page, :show_on_tutorials_page,
						 		:show_on_jobs_page, :show_on_galleries_page, :show_on_jobs_map_page,
								:show_on_companies_map_page, :show_on_jobs_list_page,
								:show_on_companies_list_page, :show_on_followings_page,
								:show_on_followers_page, :page_values

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
	  f.inputs "Widget" do
		  f.input :title
		  f.input :section_name, as: :select, collection: Widget.sections, include_blank: 'Select Widget Section', label: 'Widget Section'
		  f.input :position, as: :select, collection: Widget.positions, include_blank: 'Select Position', label: 'Position'
			f.input :ad_code, label: 'Ad Code'
			f.inputs "Show On" do
				f.input :show_on_home_page, as: :boolean, label: "Home"
				f.input :show_on_galleries_page, as: :boolean, label: "Galleries Detail"
				f.input :show_on_news_page, as: :boolean, label: "News Detail"
				f.input :show_on_downloads_page, as: :boolean, label: "Downloads Detail"
				f.input :show_on_tutorials_page, as: :boolean, label: "Tutorials Detail"
				f.input :show_on_jobs_page, as: :boolean, label: "Jobs Detail"
				f.input :show_on_jobs_list_page, as: :boolean, label: "Jobs Listing"
				f.input :show_on_jobs_map_page, as: :boolean, label: "Jobs Map"
				f.input :show_on_companies_map_page, as: :boolean, label: "Companies Map"
				f.input :show_on_followers_page, as: :boolean, label: "Connection Followers"
				f.input :show_on_followings_page, as: :boolean, label: "Connection Following"
			end
	  end
		f.actions
  end

	index :download_links => ['csv'] do
		 selectable_column
		 column :title
	   column :section_name do |sn|
			sn.section_name.capitalize
	   end
	   column :position do |p|
			 p.position.capitalize
		end
		 actions
	end

	filter :title
	filter :section_name, as: :select, collection: Widget.sections, label: 'Widget Section'
	filter :position, as: :select, collection: Widget.positions, label: 'Position'
	filter :created_at

	# Show Page
  show do
		attributes_table do
		  row :title
		  row :section_name do |s|
				s.section_name.capitalize
			end
			row :position do |p|
				p.position.capitalize
			end
		  row :ad_code
			row :show_on_home_page
			row :show_on_news_page
			row :show_on_downloads_page
			row :show_on_tutorials_page
			row :show_on_jobs_page
			row :show_on_jobs_list_page
			row :show_on_galleries_page
			row :show_on_jobs_map_page
			row :show_on_companies_map_page
			row :show_on_followers_page
			row :show_on_followings_page
		  row :created_at
		end
  end
end
