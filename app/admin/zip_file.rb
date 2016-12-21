ActiveAdmin.register ZipFile do

	menu label: 'Zip Files', parent: 'Media Library',priority: 4
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

	permit_params :zipfile, :zip_caption

	index :download_links => ['csv'] do
		   selectable_column
		   column 'Zip file' do |zf|
			 zf.zipfile
		   end
		   column 'Caption' do |itype|
			 itype.zip_caption
		   end
		 
		   actions
	  end

	filter :zip_caption

    form multipart: true do |f|
		
		f.inputs "Upload Video" do
		  f.input :zipfile,label:'Upload Zip/RAR'
		  f.input :zip_caption,label:'Caption'
		 
		end
		
		f.actions
    end
    
   	show do
		attributes_table do
		  row :zipfile
		  row :zip_caption
		  row :created_at
		end
    end



end
