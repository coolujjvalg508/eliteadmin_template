ActiveAdmin.register Advertisement,as: 'Banner' do

	menu label: 'Banners', parent: 'Pages',priority: 3
	permit_params :title,:advertisement_package_id,:starting_date,:end_date,:target_location,:interest_based, :description, :status , :images_attributes => [:id,:image,:caption_image,:imageable_id,:imageable_type, :_destroy,:tmp_image,:image_cache]


	index :download_links => ['csv'] do
     selectable_column
    column :title
    column :advertisement_package_id 	 do |pid|
		  AdvertisementPackage.find_by(id: pid.advertisement_package_id ).try(:title)
	  end

    column :starting_date
    column :end_date
   
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
					if (params[:advertisement].present? && params[:advertisement][:images_attributes].present?)
						  params[:advertisement][:images_attributes].each do |index,img|
								unless params[:advertisement][:images_attributes][index][:image].present?
									params[:advertisement][:images_attributes][index][:image] = params[:advertisement][:images_attributes][index][:image_cache]
								end
							end
					 end
					super
			end
			
			def update
					if (params[:advertisement].present? && params[:advertisement][:images_attributes].present?)
							params[:advertisement][:images_attributes].each do |index,img|
								  unless params[:advertisement][:images_attributes][index][:image].present?
									params[:advertisement][:images_attributes][index][:image]  = params[:advertisement][:images_attributes][index][:image_cache]
								  end
							end
					 end
					super
			 end

	
	end
	
	
  form multipart: true do |f|
      f.inputs "Advertisement" do
      f.input :advertisement_package_id, as: :select, collection: AdvertisementPackage.where("id IS NOT NULL").pluck(:title, :id),label:'Package', include_blank:'Select Package'
     
      f.input :title,label:'Title'
      f.input :description,label:'Description'
      f.input :starting_date, as: :date_time_picker,label:'Staring Date'
      f.input :end_date, as: :date_time_picker,label:'End Date'
      f.input :target_location,label:'Target Location'
      f.input :interest_based,label:'Interest Based'
      f.input :status, include_blank: false
      f.inputs 'Images' do
			f.has_many :images, allow_destroy: true, new_record: true do |ff|
			  ff.input :image, label: "Image", hint: ff.template.image_tag(ff.object.image.try(:url,:thumb))
			  ff.input :image_cache, :as => :hidden
			end 
	   end	 
    end

    f.actions
  end
  
  
  filter :title
  filter :advertisement_package_id, as: :select, collection: AdvertisementPackage.where("id IS NOT NULL").pluck(:title, :id), label: "Package"
  filter :status, as: :select, collection: [['Active',1], ['Inactive', 0]], label: "Status"
  filter :created_at

  
  
   # Show Page
  show do
    attributes_table do
      row :title
      row :advertisement_package_id 	 do |pid|
		  AdvertisementPackage.find_by(id: pid.advertisement_package_id).try(:title)
	  end
      row :description
      row :starting_date
      row :end_date
      row :target_location
      row :interest_based
      row 'Images' do
			ul class: "image-blk" do
				if banner.images.present?
				  banner.images.each do |img|
					span do
					  image_tag(img.try(:image).try(:thumb).try(:url), class: "show-img")
					end
				  end
				end
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
