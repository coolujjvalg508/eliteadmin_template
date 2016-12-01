ActiveAdmin.register Image do

	menu label: 'Images', parent: 'Media Library',priority: 1 
	actions :all, except: [:new, :create]
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

	permit_params :image, :caption_image
	
	
	
	controller do 

		def saveimages
			
				uploaded_io = params[:file]
				new_name	=	Time.now.to_i
				filename_new	=	''
				File.open('public/uploads/tinymic/'+ uploaded_io.original_filename, 'wb') do |file|
						File.rename(file, 'public/uploads/tinymic/'+new_name.to_s + File.extname(file))
						filename_new	=	new_name.to_s + File.extname(file)
						file.write(uploaded_io.read)
						
				end
				
				imagepath		=	'/uploads/tinymic/'+filename_new 
				render json: {
					  image: {
						url: view_context.image_url(imagepath)
					  }
					}, content_type: "text/html"
		end
	end 
	

  # Users List View
  index :download_links => ['csv'] do
	   selectable_column
	   column 'Image' do |img|
		  image_tag img.try(:image).try(:url, :thumb), height: 50, width: 50
	   end
	   column 'Imageable Type' do |itype|
		 itype.imageable_type
	   end
	   column 'Caption Image' do |itype|
		 itype.caption_image
	   end
	 
	   actions
  end

 filter :imageable_type

	form multipart: true do |f|
		
		f.inputs "Image" do
		  f.input :image
		  f.input :caption_image,label:'Caption'
		 
		end
		
		f.actions
    end

	show do
		attributes_table do
		  row :image do |img|
		   image_tag(img.try(:image).try(:thumb).try(:url), class: "show-img")
		  end
		  row :caption_image

	
		  row :created_at
		end
    end





end
