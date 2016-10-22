ActiveAdmin.register Widget do

	menu label: 'Widget', parent: 'Widget',priority: 1
	permit_params :title, :description
	actions :all, except: [:destroy, :new, :create]


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

  controller do 
	def action_methods
	 super                                    
		if current_admin_user.id.to_s == '1'
		super
	  else
		usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
		disallowed = []
		disallowed << 'index' if (!usergroup.has_permission('widget_read') && !usergroup.has_permission('widget_write') && !usergroup.has_permission('widget_delete'))
		disallowed << 'delete' unless (usergroup.has_permission('widget_delete'))
		disallowed << 'create' unless (usergroup.has_permission('widget_write'))
		disallowed << 'new' unless (usergroup.has_permission('widget_write'))
		disallowed << 'edit' unless (usergroup.has_permission('widget_write'))
		disallowed << 'destroy' unless (usergroup.has_permission('widget_delete'))
		
		super - disallowed
	  end
	end
  end





 index :download_links => ['csv'] do
     selectable_column
    
    column :title
    column :description do |cat|
		tr_con = cat.description.first(50)
    end
	column :created_at
    actions
  end



	form multipart: true do |f|
		  f.inputs "Widget" do
			f.input :title
			f.input :description
		 end

		 f.actions
	end
  
  filter :title
  filter :created_at
  
  show do
    attributes_table do
      row :title
      row :description
      row :created_at
    end
  end

end
