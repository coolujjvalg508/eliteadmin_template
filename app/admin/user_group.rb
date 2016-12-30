ActiveAdmin.register UserGroup do

	 menu label: 'User Group', parent: 'Users'
	 permit_params :name, :can_access_acp, :is_super_mod, access_control_attributes: [ :id, permissions_hash: [] ]

	 controller do 
			def action_methods
			 super                                    
				if current_admin_user.id.to_s == '1'
				super
			  else
				usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
				disallowed = []
				disallowed << 'index' if (!usergroup.has_permission('usergroup_read') && !usergroup.has_permission('usergroup_write') && !usergroup.has_permission('usergroup_delete'))
				disallowed << 'delete' unless (usergroup.has_permission('usergroup_delete'))
				disallowed << 'create' unless (usergroup.has_permission('usergroup_write'))
				disallowed << 'new' unless (usergroup.has_permission('usergroup_write'))
				disallowed << 'edit' unless (usergroup.has_permission('usergroup_write'))
				disallowed << 'destroy' unless (usergroup.has_permission('usergroup_delete'))
				
				super - disallowed
			  end
		end
	  end


	  form multipart: true do |f|
		  f.inputs "User Group" do
		  f.input :name,label: "Group Name"
		  #f.input :can_access_acp,label: "Can Access ACP"
		  f.input :is_super_mod,label: "Is Super Mod"
		end
		 f.inputs "Access Control" ,for: [:access_control, f.object.try(:access_control) || AccessControl.new], class: 'access-panel' do |permission|
		  @model_names = UserGroup::MODULESTOPERMIT
		  @model_names.each do |model|
		  key = "permissions_hash"
			if model == 'sitesetting'
			  permission.input key, as: :check_boxes, collection: [['read', "#{model}_read"], ['write', "#{model}_write"]], label: model.capitalize.split('_').collect(&:capitalize).join(' ')
			else
			  permission.input key, as: :check_boxes, collection: [['read', "#{model}_read"], ['write', "#{model}_write"], ['delete', "#{model}_delete"]], label: model.capitalize.split('_').collect(&:capitalize).join(' ')
			end 
		  end
		end

		f.actions
  end




  filter :name
  filter :created_at
  
  
   # Show Page
  show do
    attributes_table do
      row :name
      #row :can_access_acp
      row :is_super_mod
      row :created_at
    end
  end
	
	
   index :download_links => ['csv'] do
		selectable_column
		column :name
		#column :can_access_acp
		column :is_super_mod
		column :created_at
		actions
	  end
  

end
