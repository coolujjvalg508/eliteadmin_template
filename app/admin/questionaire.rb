ActiveAdmin.register Questionaire do

	menu label: 'Questionaire'
	permit_params :question, :answer
	#actions :all, except: [:new, :destroy]
	#config.filters = false
	
	controller do 
		def action_methods
		 super                                    
		 if current_admin_user.id.to_s == '1'
			super
		  else
			usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
			disallowed = []
			disallowed << 'index' if (!usergroup.has_permission('questionaire_read') && !usergroup.has_permission('questionaire_write') && !usergroup.has_permission('questionaire_delete'))
			disallowed << 'delete' unless (usergroup.has_permission('questionaire_delete'))
			disallowed << 'create' unless (usergroup.has_permission('questionaire_write'))
			disallowed << 'new' unless (usergroup.has_permission('questionaire_write'))
			disallowed << 'edit' unless (usergroup.has_permission('questionaire_write'))
			disallowed << 'destroy' unless (usergroup.has_permission('questionaire_delete'))
			
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
    
    column :question
    column :answer do |cat|
     cat.answer.html_safe
    end
 
	column :created_at
    actions
  end

	

 form multipart: true do |f|
      f.inputs "Questionaire" do
      f.input :question
      f.input :answer
     
    end

    f.actions
  end
  
  


  # Show Page
  show do
    attributes_table do
      row :question
      row :answer
     
      row :created_at
    end
  end





end
