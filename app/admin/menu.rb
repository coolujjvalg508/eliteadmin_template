ActiveAdmin.register Menu do

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

	permit_params :title,:parent_id,:url,:navigation_label,:position

	form multipart: true do |f|
		
		f.inputs "Menu" do
			  f.input :title
			 # f.input :parent_id, as: :select, collection: Menu.where("parent_id IS NULL ").pluck(:title, :id), include_blank: 'Select Parent'
			  f.input :url
			  f.input :navigation_label
			  f.input :position
		end
		
		f.actions
    end
  
  filter :title
  filter :url
  filter :navigation_label
  #filter :parent_id, as: :select, collection: Menu.where("parent_id IS NULL ").pluck(:title, :id), label: 'Parent'
	

    	# Users List View
  index :download_links => ['csv'] do
		selectable_column
    
		column :title
		column :parent do |cat|
		#  Menu.find_by(id: cat.parent_id).try(:title)
		end
		column :url
		column :navigation_label
		column :position
		column :created_at
		actions
  end

	
	


end
