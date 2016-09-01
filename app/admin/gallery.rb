ActiveAdmin.register Gallery do
    menu label: 'Gallery'
	permit_params :title,:image, :description, :post_type_category_id, 
	:medium_category_id, :subject_matter_id, :has_adult_content, 
	:software_used, :tags, :use_tag_from_previous_upload, :is_featured, 
	:status, :is_save_to_draft, :visibility, :publish, :company_logo, 
	:where_to_show, :images_attributes => [:id,:image,:imageable_id,:imageable_type, :_destroy,:tmp_image,:image_cache]
	

	form multipart: true do |f|
		
		f.inputs "Gallery" do
		  f.input :title
		  f.input :description
		  f.input :post_type_category_id, as: :select, collection: Category.where("parent_id IS NULL ").pluck(:name, :id), include_blank: false, label: 'Post Type'
		  f.input :medium_category_id, as: :select, collection: MediumCategory.where("parent_id IS NULL ").pluck(:name, :id), include_blank: false, label: 'Medium'
		  f.input :subject_matter_id, as: :select, collection: SubjectMatter.where("parent_id IS NULL ").pluck(:name, :id), include_blank: false, label: 'Subject Matter'
		  f.input :has_adult_content, as: :select, collection: [['Yes',1],['No',0]], include_blank: false
		  f.input :software_used, label: 'Add the software used on this project'
		  f.input :tags, label:'Tags (use tags to add more detailed subject matter)'
		  f.input :use_tag_from_previous_upload, as: :select, collection: [['Yes',1],['No',0]], include_blank: false
		  f.input :is_featured, as: :select, collection: [['Yes',1],['No',0]], include_blank: false, label: 'Feature this Post'
		  f.input :status, as: :select, collection: [['Active',1], ['Inactive', 0]], include_blank: false
		  f.input :is_save_to_draft, as: :select, collection: [['Yes',1], ['No', 0]], include_blank: false, label: 'Save Draft'
		  f.input :visibility, as: :select, collection: [['Private',1], ['Public', 0]], include_blank: false
		  f.input :publish, as: :select, collection: [['Yes',1], ['No', 0]], include_blank: false
		  f.input :company_logo
			  
		  f.inputs 'Images' do
			f.has_many :images, allow_destroy: true, new_record: true do |ff|
			  ff.input :image, label: "Image", hint: ff.template.image_tag(ff.object.image.try(:url,:thumb))
			  ff.input :image_cache, :as => :hidden
			end
		  end	
		end
		
	f.actions
  end
  
  controller do
	  def create
			if (params[:gallery].present? && params[:gallery][:images_attributes].present?)
			params[:gallery][:images_attributes].each do |index,img|
			  unless params[:gallery][:images_attributes][index][:image].present?
				params[:gallery][:images_attributes][index][:image] = params[:gallery][:images_attributes][index][:image_cache]
			  end
			end
			super
		  else
			super
		  end
		end

		def update
			if (params[:gallery].present? && params[:gallery][:images_attributes].present?)
			
			params[:gallery][:images_attributes].each do |index,img|
			  unless params[:gallery][:images_attributes][index][:image].present?
				params[:gallery][:images_attributes][index][:image] = params[:gallery][:images_attributes][index][:image_cache]
			  end
			end
			super
		  else
			super
		  end
		end
  end

  filter :title
  filter :tags
  filter :post_type_category_id, as: :select, collection: Category.where("parent_id IS NULL ").pluck(:name, :id), label: 'Post Type'
  filter :medium_category_id, as: :select, collection: MediumCategory.where("parent_id IS NULL ").pluck(:name, :id), label: 'Medium'
  filter :subject_matter_id, as: :select, collection: SubjectMatter.where("parent_id IS NULL ").pluck(:name, :id), label: 'Subject Matter'
  filter :has_adult_content, as: :select, collection: [['Yes',1], ['No', 0]], label: 'Adult content'
  filter :status, as: :select, collection: [['Active',1], ['Inactive', 0]], label: 'Status'
  filter :is_featured, as: :select, collection: [['Yes',1], ['No', 0]], label: 'Featured'
  filter :created_at

  
   # Users List View
  index :download_links => ['csv'] do
	   selectable_column
	   column 'title' 
	   column 'Description' do |description|
		  tr_con = description.description.first(45)
	   end
	   column :post_type_category_id do |cat|
		  Category.find_by(id: cat.post_type_category_id).try(:name)
	   end
	   column :medium_category_id do |cat|
		  MediumCategory.find_by(id: cat.medium_category_id).try(:name)
	   end
	  column :subject_matter_id do |cat|
		  SubjectMatter.find_by(id: cat.subject_matter_id).try(:name)
	   end

	   column 'Status' do |user|
		  user.status? ? 'Active' : 'Inactive'
		end
		actions
  end
    
  
   show do
		attributes_table do
		  row :title
		  row :description
		  row :post_type_category_id do |cat|
		    Category.find_by(id: cat.post_type_category_id).try(:name)
		  end
		  row :medium_category_id do |cat|
		    MediumCategory.find_by(id: cat.medium_category_id).try(:name)
		  end
		  row :subject_matter_id do |cat|
		    SubjectMatter.find_by(id: cat.subject_matter_id).try(:name)
		  end
		  row :has_adult_content do |hac|
		    hac.has_adult_content? ? 'Yes' : 'No'
		  end

		  row :software_used
		  row :tags
		  row :use_tag_from_previous_upload do |utag|
		    utag.use_tag_from_previous_upload? ? 'Yes' : 'No'
		  end
		  row :is_featured do |ifeature|
		    ifeature.is_featured? ? 'Yes' : 'No'
		  end
		  row :status do |st|
		    st.status? ? 'Active' : 'Inactive'
		  end
		  row :is_save_to_draft do |st|
		    st.is_save_to_draft? ? 'Yes' : 'No'
		  end
		  row :visibility do |st|
		    st.visibility? ? 'Private' : 'Public'
		  end
		  row :publish do |st|
		    st.publish? ? 'Yes' : 'No'
		  end

		  row :company_logo do |cat|
			unless !cat.company_logo.present?
			  image_tag(cat.try(:company_logo).try(:url, :event_small))
			else
			  image_tag('/assets/default-blog.png', height: '50', width: '50')
			end
		  end
		  
		  row 'Images' do
			ul class: "image-blk" do
				if gallery.images.present?
				  gallery.images.each do |img|
					span do
					  image_tag(img.try(:image).try(:thumb).try(:url), class: "show-img")
					end
				  end
				end
			end
		  end
		  
		  
		  
		  row :where_to_show do |st|
		    st.where_to_show? ? 'On CGmeetup' : 'On Website'
		  end
		  row :created_at
		end
    end


	csv do
		column :title
		column :description
		column 'Post Type' do |cat|
			Category.find_by(id: cat.post_type_category_id).try(:name)
		end
		column :medium_category_id do |cat|
		    MediumCategory.find_by(id: cat.medium_category_id).try(:name)
		  end
		column :subject_matter_id do |cat|
		    SubjectMatter.find_by(id: cat.subject_matter_id).try(:name)
		  end
		column :has_adult_content do |hac|
		    hac.has_adult_content? ? 'Yes' : 'No'
		  end

		column :software_used
		column :tags
	    column :use_tag_from_previous_upload do |utag|
		    utag.use_tag_from_previous_upload? ? 'Yes' : 'No'
		  end
		column :is_featured do |ifeature|
			ifeature.is_featured? ? 'Yes' : 'No'
		  end
		column :status do |st|
			st.status? ? 'Active' : 'Inactive'
		  end
		column :is_save_to_draft do |st|
			st.is_save_to_draft? ? 'Yes' : 'No'
		  end
		column :visibility do |st|
			st.visibility? ? 'Private' : 'Public'
		  end
		column :publish do |st|
			st.publish? ? 'Yes' : 'No'
		  end
		  
		column :created_at
		
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
