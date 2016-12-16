ActiveAdmin.register Widget do

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

	 menu label: 'Widget'
	 permit_params :title, :sectionname, :widgetcode, :position, :status,:sort_order

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


	  form multipart: true do |f|
		  f.inputs "Widget" do
			  f.input :title
			  f.input :sectionname, as: :select, collection: [['Gallery','Gallery'],['Challenges','Challenges'],['User','User'],['Downloads','Downloads'],['Tutorial','Tutorial'],['Jobs','Jobs'],['News','News'],['Forum','Forum']], include_blank: 'Select Widget Section', label: 'Widget Section'
			  f.input :widgetcode, label: 'Widget Code'
			  f.input :position, as: :select, collection: [['Top','Top'],['Left','Left'],['Right','Right'],['Bottom','Bottom']], include_blank: 'Select Position', label: 'Position'
			  f.input :status, as: :select, collection: [['Active',1],['Inactive',0]], include_blank: 'Status', label: 'Status'
			  f.input :sort_order, label: 'Order'
		  end

			f.actions
	  end



	index :download_links => ['csv'] do
		 selectable_column
	
		 column :title
		   column :section_name do |sn|
				sn.sectionname
		   end
		  column :position
		  column :status do |sn|
				(sn.status == 1) ? 'Active' :'Inactive'
		   end
	
		  column :sort_order
		  column :created_at
		actions
	  end
	  
	filter :title
	filter :sectionname, as: :select, collection: [['Gallery','Gallery'],['Challenges','Challenges'],['User','User'],['Downloads','Downloads'],['Tutorial','Tutorial'],['Jobs','Jobs'],['News','News'],['Forum','Forum']], label: 'Widget Section'
	filter :position, as: :select, collection: [['Top','Top'],['Left','Left'],['Right','Right'],['Bottom','Bottom']], label: 'Position'
	filter :status, as: :select, collection: [['Active',1],['Inactive',0]], label: 'Status'
	filter :created_at  
	  

	# Show Page
	  show do
		attributes_table do

		  row :title
		   row :section_name do |sn|
				sn.sectionname
		   end
		  row :widgetcode
		  row :position
		  row :status do |sn|
				(sn.status == 1) ? 'Active' :'Inactive'
		   end
	
		  row :sort_order
		  row :created_at
		end
	  end



end
