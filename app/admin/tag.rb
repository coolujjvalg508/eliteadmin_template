ActiveAdmin.register Tag do
	menu label: 'Tag'
	permit_params :title,:tags

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
	   column 'title' 
	   column 'tags' 
	   column 'created_at' 
	   column 'updated_at' 
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
