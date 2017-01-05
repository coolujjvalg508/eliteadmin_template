ActiveAdmin.register Tag do

	#menu false
	menu label: 'Tags',priority: 11
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

	permit_params :tag

	index :download_links => ['csv'] do
		   selectable_column
		   column 'Tag' do |itype|
			 itype.tag
		   end
		   column 'Tag Section' do |itype|
			 itype.tagable_type 	
		   end
		   actions
	  end

	filter :tag
	filter :tagable_type

    form multipart: true do |f|
		
		f.inputs "Upload Video" do
		  f.input :tag,label:'Tag'		 
		end
		f.actions
    end
    
   	show do
		attributes_table do
		
		  row :tag
		   row 'Tag Section' do |itype|
			 itype.tagable_type 	
		   end
		  row :created_at
		end
    end



end
