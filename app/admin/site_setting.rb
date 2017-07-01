ActiveAdmin.register SiteSetting do

    menu label: 'Site Setting', parent: 'Settings',priority: 1 
	permit_params :site_title,:site_email,:address , :home_page_layout_type, :site_phone, :show_news, :show_behind_the_scenes ,:instagram_like_count ,:instagram_link ,:youtube_like_count ,:youtube_link ,:google_plus_like_count ,:google_plus_link ,:twitter_like_count ,:twitter_link ,:facebook_like_count ,:facebook_link ,:show_top_categories ,:show_top_artists ,:show_latest_post ,:show_downloads ,:show_job_updates ,:show_movies_film_trailor ,:show_news_press_release ,:show_tutorials , :show_community ,:copyright_text,:no_of_image,:no_of_video,:no_of_marmoset,:no_of_sketchfeb,:licence
	actions :all, except: [:destroy, :new, :create]
	config.filters = false

	controller do 
	def action_methods
	 super                                    
		if current_admin_user.id.to_s == '1'
		super
	  else
		usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
		disallowed = []
		disallowed << 'index' if (!usergroup.has_permission('sitesetting_read') && !usergroup.has_permission('sitesetting_write') && !usergroup.has_permission('sitesetting_delete'))
		disallowed << 'delete' unless (usergroup.has_permission('sitesetting_delete'))
		disallowed << 'create' unless (usergroup.has_permission('sitesetting_write'))
		disallowed << 'new' unless (usergroup.has_permission('sitesetting_write'))
		disallowed << 'edit' unless (usergroup.has_permission('sitesetting_write'))
		disallowed << 'destroy' unless (usergroup.has_permission('sitesetting_delete'))
		
		super - disallowed
	  end
	end
  end


  	show do
	    attributes_table do
	      row :site_title
	      row :site_email
	      row :site_phone
	      row :copyright_text
	      row :licence
	      row 'Homepage layout' do |st|
			st.home_page_layout_type? ? '12 Rows' : '7 Rows'
		  end
		  row :address
	      row :facebook_link
	      row :facebook_like_count
	      row :twitter_link
	      row :twitter_like_count
	      row :google_plus_link
	      row :google_plus_like_count
	      row :youtube_link
	      row :youtube_like_count
	      row :instagram_link
	      row :instagram_like_count
	      row :show_news
	      row :show_community
	      row :show_behind_the_scenes
	      row :show_tutorials
	      row :show_news_press_release
	      row :show_movies_film_trailor
	      row :show_job_updates
	      row :show_downloads
	      row :show_latest_post
	      row :show_top_artists
	      row :show_top_categories
	    end
  	end
    form multipart: true do |f|
			
		  f.inputs "Site Setting" do
			  f.input :site_title, label:'Site Title'
			  f.input :site_email, label:'Site Email'
			  f.input :site_phone, label:'Site Phone'
			  f.input :copyright_text, label:'Copyright Text'
			  f.input :licence, label:'General Licence Content'
			  f.input :address, label:'Address'
			  f.input :home_page_layout_type, as: :select, collection: [['12 Rows',1], ['7 Rows', 0]], include_blank: false
			  f.input :facebook_link, label:'Facebook link'
			  f.input :facebook_like_count, label:'Facebook like count'
			  f.input :twitter_link, label:'Twitter link'
			  f.input :twitter_like_count, label:'Twitter like count'
			  f.input :google_plus_link, label:'Google+ link'
			  f.input :google_plus_like_count, label:'Google+ like count'
			  f.input :youtube_link, label:'Youtube link'
			  f.input :youtube_like_count, label:'Youtube like count'
			  f.input :instagram_link, label:'Instagram link'
			  f.input :instagram_like_count, label:'Instagram like count'
			  f.input :show_news, label:'Show News'
			  f.input :show_community, label:'Show Comunity'
			  f.input :show_behind_the_scenes, label:'Show Behind the scenes, making of '
			  f.input :show_tutorials, label:'Show Tutorials - Free Source of 2D & 3D '
			  f.input :show_news_press_release, label:'Show News and Press Release'
			  f.input :show_movies_film_trailor, label:'Show Movies Film Trailors'
			  f.input :show_job_updates, label:'Show Job Updates'
			  f.input :show_downloads, label:'Show Downloads'
			  f.input :show_latest_post, label:'Show Latest Post'
			  f.input :show_top_artists, label:'Show Top Artists'
			  f.input :show_top_categories, label:'Show Top Categories'
		  end
			
			
		f.actions
	  end


   # Users List View
	  index :download_links => ['csv'] do
		   selectable_column
		   column 'Site Title' do |st|
				st.site_title
		   end
		   column 'Site Email' do |st|
				st.site_email
		   end
		   column 'Site Phone' do |st|
				st.site_phone
		   end
		   column 'Copyright Text' do |st|
				st.copyright_text
		   end
		   column 'Homepage layout' do |st|
				st.home_page_layout_type? ? '12 Rows' : '7 Rows'
		   end
		   actions
	  end



end
