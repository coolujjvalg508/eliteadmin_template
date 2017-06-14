ActiveAdmin.register TutorialSubject do
	menu label: 'Subject', parent: 'Tutorial',priority: 4
	permit_params :name, :parent_id, :image, :description, :slug, :status, :topic_id
	actions :all, except: [:destroy]

	controller do 
		def action_methods
		 super                                    
		 if current_admin_user.id.to_s == '1'
			super
		  else
			usergroup  = UserGroup.where(:id => current_admin_user.group_id.to_s).first
			disallowed = []
			disallowed << 'index' if (!usergroup.has_permission('tutorial_subject_read') && !usergroup.has_permission('tutorial_subject_write') && !usergroup.has_permission('tutorial_subject_delete'))
			disallowed << 'delete' unless (usergroup.has_permission('tutorial_subject_delete'))
			disallowed << 'create' unless (usergroup.has_permission('tutorial_subject_write'))
			disallowed << 'new' unless (usergroup.has_permission('tutorial_subject_write'))
			disallowed << 'edit' unless (usergroup.has_permission('tutorial_subject_write'))
			disallowed << 'destroy' unless (usergroup.has_permission('tutorial_subject_delete'))
			
			super - disallowed
		  end
		end
	end



	index :download_links => ['csv'] do
		selectable_column    
		column :name
    	column :parent do |cat|
			TutorialSubject.find_by(id: cat.parent_id).try(:name)
    	end
    	column 'Image' do |img|
		image_tag img.try(:image).try(:url, :thumb), height: 50, width: 50
    	end
		column :created_at
    	actions
  	end

  	controller do
			def create
			  unless params[:tutorial_subject][:image].present?
				params[:tutorial_subject][:image] = params[:tutorial_subject][:image_cache]
				super
			  else
				super
			  end
			end
	end


	 form multipart: true do |f|
      f.inputs "Tutorial Subject" do
      	f.input :topic_id, as: :select, collection: Topic.where("id IS NOT NULL ").pluck(:name, :id), include_blank: 'Select Topic'
      f.input :parent_id, as: :select, collection: TutorialSubject.where("parent_id IS NULL ").pluck(:name, :id), include_blank: 'Select Parent'
      #f.input :parent_id, :as => :select
      f.input :image      
      f.input :name
      f.input :description
      f.input :slug
    end

    f.actions
  end
  
  filter :name
  filter :created_at


 # Show Page
  show do
    attributes_table do
      row :name
      row :parent do |cat|
       TutorialSubject.find_by(id: cat.parent_id).try(:name)
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
