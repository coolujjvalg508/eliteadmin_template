ActiveAdmin.register PostType do

	menu label: 'Post Type' , parent: 'Download', priority: 3
	permit_params :type_name

	controller do 
		def action_methods
		 super                                    
		 if current_admin_user.id.to_s == '1'
			super
		  else
			usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
			disallowed = []
			disallowed << 'index' if (!usergroup.has_permission('post_type_read') && !usergroup.has_permission('post_type_write') && !usergroup.has_permission('post_type_delete'))
			disallowed << 'delete' unless (usergroup.has_permission('post_type_delete'))
			disallowed << 'create' unless (usergroup.has_permission('post_type_write'))
			disallowed << 'new' unless (usergroup.has_permission('post_type_write'))
			disallowed << 'edit' unless (usergroup.has_permission('post_type_write'))
			disallowed << 'destroy' unless (usergroup.has_permission('post_type_delete'))
			
			super - disallowed
		  end
		end
	end
	
	index :download_links => ['csv'] do
		selectable_column
    
		column :type_name
		column :created_at
		actions
    end


	 form multipart: true do |f|
		  f.inputs "Post Type" do
		  f.input :type_name
		end

		f.actions
	  end
	
	filter :type_name
 
	 # Show Page
	  show do
			attributes_table do
			  row :type_name
			  row :created_at
			end
	  end


end
