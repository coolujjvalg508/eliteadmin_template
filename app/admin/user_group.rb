ActiveAdmin.register UserGroup do

	 menu label: 'User Group', parent: 'Users'
	 permit_params :name, :can_access_acp, :is_super_mod, access_control_attributes: [ :id, permissions_hash: [] ]

	  form multipart: true do |f|
		  f.inputs "User Group" do
		  f.input :name,label: "Group Name"
		  f.input :can_access_acp,label: "Can Access ACP"
		  f.input :is_super_mod,label: "Is Super Mod"
		end
		 f.inputs "Access Control" ,for: [:access_control, f.object.try(:access_control) || AccessControl.new], class: 'access-panel' do |permission|
		  @model_names = UserGroup::MODULESTOPERMIT
		  @model_names.each do |model|
		  key = "permissions_hash"
			if model == 'sitesetting'
			  permission.input key, as: :check_boxes, collection: [['read', "#{model}_read"], ['write', "#{model}_write"]], label: model.capitalize
			else
			  permission.input key, as: :check_boxes, collection: [['read', "#{model}_read"], ['write', "#{model}_write"], ['delete', "#{model}_delete"]], label: model.capitalize
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
      row :can_access_acp
      row :is_super_mod
      row :created_at
    end
  end
	
	
   index :download_links => ['csv'] do
		selectable_column
		column :name
		column :can_access_acp
		column :is_super_mod
		column :created_at
		actions
	  end
  

end
