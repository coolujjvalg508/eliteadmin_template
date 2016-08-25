ActiveAdmin.register Advertisement do

	menu label: 'Advertisement'
	permit_params :title, :description, :image, :status


	index :download_links => ['csv'] do
     selectable_column
    
    column :title
   
    column 'Image' do |img|
      image_tag img.try(:image).try(:url, :thumb), height: 50, width: 50
    end
    column 'Description' do |advertisement|
      tr_con = advertisement.description.first(50)
      tr_con.html_safe
    end
	column :status
	column :created_at
    actions
  end




	 controller do
			def create
			  unless params[:advertisement][:image].present?
				params[:advertisement][:image] = params[:advertisement][:image_cache]
				super
			  else
				super
			  end
			end
	end
	
	
	form multipart: true do |f|
      f.inputs "Advertisement" do
      f.input :image
      f.input :title
      f.input :description
      f.input :status, include_blank: false
    end

    f.actions
  end
  
  filter :title
  filter :status, as: :select, collection: [['Active',1], ['Inactive', 0]], label: "Status"
  filter :created_at

  
  
   # Show Page
  show do
    attributes_table do
      row :title
      row :description
      row :image do |cat|
        unless !cat.image.present?
          image_tag(cat.try(:image).try(:url, :event_small))
        else
          image_tag('/assets/default-blog.png', height: '50', width: '50')
        end
      end
      row :status
      row :created_at
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


end
