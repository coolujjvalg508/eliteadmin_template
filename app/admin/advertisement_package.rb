ActiveAdmin.register AdvertisementPackage do

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

	 menu label: 'Advertisement Package', parent: 'Package',priority: 2
	 permit_params :title, :description, :amount, :image

	  form multipart: true do |f|
		  f.inputs "Advertisement Package" do
			  f.input :image
			  f.input :title
			  f.input :description
			  f.input :amount
		  end

			f.actions
	  end

	   controller do
			def create
			  unless params[:advertisement_package][:image].present?
				params[:advertisement_package][:image] = params[:advertisement_package][:image_cache]
				super
			  else
				super
			  end
			end
	end

	index :download_links => ['csv'] do
		 selectable_column
		
		column 'Image' do |img|
		  image_tag img.try(:image).try(:url, :thumb), height: 50, width: 50
		end
		column :title
		column :description do |description|
		   tr_con = description.description.first(45)
		end
		
		column :amount
		column :created_at
		actions
	  end
	  
	filter :title
	filter :created_at  
	  

	# Show Page
	  show do
		attributes_table do
			  row :image do |cat|
				unless !cat.image.present?
				  image_tag(cat.try(:image).try(:url, :event_small))
				else
				  image_tag('/assets/default-blog.png', height: '50', width: '50')
				end
			  end
		  row :title
		  row :description do |description|
				tr_con = description.description.first(45)
		   end
		  row :amount
		  row :created_at
		end
	  end
	
end
