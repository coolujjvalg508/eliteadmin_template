ActiveAdmin.register Invitation do

  menu label: 'Invitation'
  permit_params :email,:status
  actions :all, except: [:new, :destroy]
  form multipart: true do |f|
		
		f.inputs "Invitation" do
		  f.input :email
		  f.input :status, as: :select, collection: [['Active',1], ['Inactive', 0]], include_blank: false
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
			disallowed << 'index' if (!usergroup.has_permission('invitation_read') && !usergroup.has_permission('invitation_write') && !usergroup.has_permission('invitation_delete'))
			disallowed << 'delete' unless (usergroup.has_permission('invitation_delete'))
			disallowed << 'create' unless (usergroup.has_permission('invitation_write'))
			disallowed << 'new' unless (usergroup.has_permission('invitation_write'))
			disallowed << 'edit' unless (usergroup.has_permission('invitation_write'))
			disallowed << 'destroy' unless (usergroup.has_permission('invitation_delete'))
			
			super - disallowed
		  end
	end
  end
  
  filter :email
  
 index :download_links => ['csv'] do
		selectable_column
		column :inviter_name do |cat|
			userdata	=	User.find(cat.user_id)
			userdata.firstname
		end
		column :email
		column :created_at
		actions
	  end
	  
	   filter :name
       filter :created_at


  # Show Page
  show do
    attributes_table do
      row :inviter_name do |cat|
		userdata	=	User.find(cat.user_id)
		userdata.firstname
	  end
      row :email
      row :created_at
    end
  end
  
  csv do
		column :inviter_name do |cat|
			userdata	=	User.find(cat.user_id)
			userdata.firstname
		end
		column :email
		column :created_at
		
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
