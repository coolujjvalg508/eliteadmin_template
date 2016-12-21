ActiveAdmin.register PostType do

	menu label: 'Post Type' , parent: 'Downloads', priority: 3
	permit_params :type_name, :parent_id, :image, :description, :slug
	
	controller do 
		def action_methods
		 super                                    
		 if current_admin_user.id.to_s == '1'
			super
		  else
			usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
			disallowed = []
			disallowed << 'index' if (!usergroup.has_permission('post_type_read') && !usergroup.has_permission('post_type_write') && !usergroup.has_permission('post_type_delete'))
			disallowed << 'delete' unless (usergroup.has_permission('post_type_delete'))
			disallowed << 'create' unless (usergroup.has_permission('post_type_write'))
			disallowed << 'new' unless (usergroup.has_permission('post_type_write'))
			disallowed << 'edit' unless (usergroup.has_permission('post_type_write'))
			disallowed << 'destroy' unless (usergroup.has_permission('post_type_delete'))
			
			super - disallowed
		  end
		end
	end
	
	 controller do
			def create
			  unless params[:post_type][:image].present?
				params[:post_type][:image] = params[:post_type][:image_cache]
				super
			  else
				super
			  end
			end
	end
	
	index :download_links => ['csv'] do
		 selectable_column
		
		column :type_name
		column :parent do |cat|
		  PostType.find_by(id: cat.parent_id).try(:name)
		end
		column 'Image' do |img|
		  image_tag img.try(:image).try(:url, :thumb), height: 50, width: 50
		end
		column :created_at
		actions
	  end


	 form multipart: true do |f|
		  f.inputs "Post Type" do
		   f.input :parent_id, as: :select, collection: PostType.where("parent_id IS NULL").pluck(:type_name, :id), include_blank: 'Select Parent'
		   f.input :image
		   f.input :type_name
		   f.input :description
		   f.input :slug
		end

		f.actions
	  end
	
	filter :type_name
	filter :created_at
 
	 # Show Page
	  show do
    attributes_table do
      row :type_name
      row :parent do |cat|
       PostType.find_by(id: cat.parent_id).try(:name)
     end
      row :image do |cat|
        unless !cat.image.present?
          image_tag(cat.try(:image).try(:url, :event_small))
        else
          image_tag('/assets/default-blog.png', height: '50', width: '50')
        end
      end
      row :created_at
    end
  end


end
