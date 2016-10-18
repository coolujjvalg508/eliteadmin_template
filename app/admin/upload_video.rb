ActiveAdmin.register UploadVideo do

menu label: 'Uploaded Videos', parent: 'Media Library',priority: 3
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

	permit_params :uploadvideo,:caption_upload_video

	index :download_links => ['csv'] do
		   selectable_column
		   column 'Video' do |img|
				raw('<iframe title="Video" width="250" height="200" src="'+img.uploadvideo.url+'" frameborder="0" allowfullscreen></iframe>')
		   end
		   column 'Upload Videoable Type' do |itype|
			 itype.uploadvideoable_type
		   end
		   column 'Caption Video' do |itype|
			 itype.caption_upload_video
		   end
		 
		   actions
	  end

	filter :uploadvideoable_type

    form multipart: true do |f|
		
		f.inputs "Upload Video" do
		  f.input :uploadvideo,label:'Upload Video'
		  f.input :caption_upload_video,label:'Caption'
		 
		end
		
		f.actions
    end
    
   	show do
		attributes_table do
		  row :video do |img|
				raw('<iframe title="Video" width="250" height="200" src="'+img.uploadvideo.url+'" frameborder="0" allowfullscreen></iframe>')
		  end
		  row :caption_upload_video
		  row :created_at
		end
    end


end
