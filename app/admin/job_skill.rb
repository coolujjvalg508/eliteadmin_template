ActiveAdmin.register JobSkill, as: "Skills" do
	 menu label: 'Skills', parent: 'User Setting',priority: 1
	 permit_params :name, :parent_id, :image, :description, :slug

	  form multipart: true do |f|
		  f.inputs "Job Skill" do
		  f.input :parent_id, as: :select, collection: JobSkill.where("parent_id IS NULL ").pluck(:name, :id), include_blank: 'Select Parent'
		  #f.input :parent_id, :as => :select
		  f.input :image
		  f.input :name
		  f.input :description
		  f.input :slug
		end

		f.actions
  end
  
  controller do 
		def action_methods
		 super                                    
			if current_admin_user.id.to_s == '1'
			super
		  else
			usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
			disallowed = []
			disallowed << 'index' if (!usergroup.has_permission('jobskill_read') && !usergroup.has_permission('jobskill_write') && !usergroup.has_permission('jobskill_delete'))
			disallowed << 'delete' unless (usergroup.has_permission('jobskill_delete'))
			disallowed << 'create' unless (usergroup.has_permission('jobskill_write'))
			disallowed << 'new' unless (usergroup.has_permission('jobskill_write'))
			disallowed << 'edit' unless (usergroup.has_permission('jobskill_write'))
			disallowed << 'destroy' unless (usergroup.has_permission('jobskill_delete'))
			
			super - disallowed
		  end
	end
  end
  
  
  

   controller do
			def create
			  unless params[:job_skill][:image].present?
				params[:job_skill][:image] = params[:job_skill][:image_cache]
				super
			  else
				super
			  end
			end
	end
	
	index :download_links => ['csv'] do
		 selectable_column
		
		column :name
		column :parent do |cat|
		  JobSkill.find_by(id: cat.parent_id).try(:name)
		end
		column 'Image' do |img|
		  image_tag img.try(:image).try(:url, :thumb), height: 50, width: 50
		end
		column :created_at
		actions
	  end

	
  filter :name
  filter :created_at


  # Show Page
  show do
    attributes_table do
      row :name
      row :parent do |cat|
       JobSkill.find_by(id: cat.parent_id).try(:name)
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
