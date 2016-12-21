ActiveAdmin.register JobCategory , as: "Contract Type" do
  
  menu label: 'Contract Type', parent: 'Job Management',priority: 2
  permit_params :name

  form multipart: true do |f|
		
		f.inputs "Contract Type Category" do
		  f.input :name
		end
		
		f.actions
  end


	controller do 
		def action_methods
		 super                                    
			if current_admin_user.id.to_s == '1'
			super
		  else
			usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
			disallowed = []
			disallowed << 'index' if (!usergroup.has_permission('jobcategory_read') && !usergroup.has_permission('jobcategory_write') && !usergroup.has_permission('jobcategory_delete'))
			disallowed << 'delete' unless (usergroup.has_permission('jobcategory_delete'))
			disallowed << 'create' unless (usergroup.has_permission('jobcategory_write'))
			disallowed << 'new' unless (usergroup.has_permission('jobcategory_write'))
			disallowed << 'edit' unless (usergroup.has_permission('jobcategory_write'))
			disallowed << 'destroy' unless (usergroup.has_permission('jobcategory_delete'))
			
			super - disallowed
		  end
		end
	  end
	
	



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


end
