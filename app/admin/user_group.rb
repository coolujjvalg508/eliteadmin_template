ActiveAdmin.register UserGroup do

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

 menu label: 'User Group', parent: 'Users'
	 permit_params :name, :can_access_acp, :is_super_mod

	  form multipart: true do |f|
		  f.inputs "User Group" do
		  f.input :name,label: "Group Name"
		  f.input :can_access_acp,label: "Can Access ACP"
		  f.input :is_super_mod,label: "Is Super Mod"
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
