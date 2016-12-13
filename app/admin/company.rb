ActiveAdmin.register Company do

	menu label: 'Company'
	permit_params :name, :email

	
	controller do 
		def action_methods
		 super                                    
		 if current_admin_user.id.to_s == '1'
			super
		  else
			usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
			disallowed = []
			disallowed << 'index' if (!usergroup.has_permission('company_read') && !usergroup.has_permission('company_write') && !usergroup.has_permission('company_delete'))
			disallowed << 'delete' unless (usergroup.has_permission('company_delete'))
			disallowed << 'create' unless (usergroup.has_permission('company_write'))
			disallowed << 'new' unless (usergroup.has_permission('company_write'))
			disallowed << 'edit' unless (usergroup.has_permission('company_write'))
			disallowed << 'destroy' unless (usergroup.has_permission('company_delete'))
			
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
  	# Users List View
  index :download_links => ['csv'] do
     selectable_column
    column :username do |cat|

		if cat.user_id 
			userdata	=	User.find(cat.user_id)
			userdata.firstname
		else
			'Admin'
		end	
		
    end
    column :name
    column :email
    
	column :created_at
    actions
  end

	 controller do
			def create
			  unless params[:company][:name].present?
					params[:company][:user_id] = current_admin_user.id
				super
			  else
				super
			  end
			end
	end


 form multipart: true do |f|
      f.inputs "Category" do
      f.input :name 
      f.input :email
    end

    f.actions
  end
  
  filter :name
  filter :email
  filter :created_at


  # Show Page
  show do
    attributes_table do
    
   row :username do |cat|

		if cat.user_id 
			userdata	=	User.find(cat.user_id)
			userdata.firstname
		else
			'Admin'
		end	
		
    end
    row :name
    row :email
    
	row :created_at
	
     
    end
  end
  
  csv do
		column :username do |cat|
			if cat.user_id 
				userdata	=	User.find(cat.user_id)
				userdata.firstname
			else
				'Admin'
			end	
		end
		column :name
		column :email
    
		column :created_at

		
		
  end


end
