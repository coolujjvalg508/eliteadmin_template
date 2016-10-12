ActiveAdmin.register AdminUser do
  menu label: 'Admin User', parent: 'Users'
  permit_params :email, :password, :password_confirmation,:group_id
  
  controller do 
		def action_methods
		 super                                    
			if current_admin_user.id.to_s == '1'
			super
		  else
			usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
				if usergroup.can_access_acp == true
					super
				else
					disallowed = []
					disallowed << 'index' if (!usergroup.has_permission('adminuser_read') && !usergroup.has_permission('adminuser_write') && !usergroup.has_permission('adminuser_delete'))
					disallowed << 'delete' unless (usergroup.has_permission('adminuser_delete'))
					disallowed << 'create' unless (usergroup.has_permission('adminuser_write'))
					disallowed << 'new' unless (usergroup.has_permission('adminuser_write'))
					disallowed << 'edit' unless (usergroup.has_permission('adminuser_write'))
					disallowed << 'destroy' unless (usergroup.has_permission('adminuser_delete'))
					
					super - disallowed
				end	
		  end
	end
  end
  
  
 
 index :download_links => ['csv'] do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
 
	actions
    
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :group_id, as: :select, collection:  UserGroup.where("name != '' ").pluck(:name, :id),label:'Select Group',include_blank:'Select Group'	
    end
    f.actions
    
  end
  

end
