ActiveAdmin.register Tag do
	menu label: 'Tag'
	permit_params :title,:tags

	controller do 
		def action_methods
		 super                                    
			if current_admin_user.id.to_s == '1'
			super
		  else
			usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
			disallowed = []
			disallowed << 'index' if (!usergroup.has_permission('tag_read') && !usergroup.has_permission('tag_write') && !usergroup.has_permission('tag_delete'))
			disallowed << 'delete' unless (usergroup.has_permission('tag_delete'))
			disallowed << 'create' unless (usergroup.has_permission('tag_write'))
			disallowed << 'new' unless (usergroup.has_permission('tag_write'))
			disallowed << 'edit' unless (usergroup.has_permission('tag_write'))
			disallowed << 'destroy' unless (usergroup.has_permission('tag_delete'))
			
			super - disallowed
		  end
	end
  end




	form multipart: true do |f|
		
		f.inputs "Tag" do
			  f.input :title
			  f.input :tags, label:'Tags'
		end
		f.actions
	end

  filter :title
  filter :tags
  filter :created_at
  
    # Users List View
  index :download_links => ['csv'] do
	   selectable_column
	    column 'Title' do |title|
		 title.title
	   end
	    column 'Tags' do |title|
		 title.tags
	   end
	    column 'Updated' do |title|
		 title.updated_at
	   end
	    column 'Created' do |title|
		 title.created_at
	   end
	  
	  actions
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
