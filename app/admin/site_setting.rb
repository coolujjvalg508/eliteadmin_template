ActiveAdmin.register SiteSetting do

    menu label: 'Site Setting'
	permit_params :site_title,:site_email,:site_phone,:copyright_text,:no_of_image,:no_of_video,:no_of_marmoset,:no_of_sketchfeb
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



    form multipart: true do |f|
			
		  f.inputs "Site Setting" do
			  f.input :site_title, label:'Site Title'
			  f.input :site_email, label:'Site Email'
			  f.input :site_phone, label:'Site Phone'
			  f.input :copyright_text, label:'Copyright Text'
			  f.input :no_of_image, label:'No of Images'
			  f.input :no_of_video, label:'No of Videos'
			  f.input :no_of_marmoset, label:'No of Marmoset'
			  f.input :no_of_sketchfeb, label:'No of Sketchfeb'
		
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
		   column 'No of Images' do |st|
				st.no_of_image
		   end
		   column 'No of Videos' do |st|
				st.no_of_video
		   end
		   column 'No of Marmosets' do |st|
				st.no_of_marmoset
		   end
		   column 'No of Sketchfeb' do |st|
				st.no_of_sketchfeb
		   end
		   actions
	  end



end
