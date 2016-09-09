ActiveAdmin.register Gallery , as: "Project" do
    menu label: 'Projects', parent: 'Gallery',priority: 1

	permit_params :title,:paramlink,:image, :description, :post_type_category_id, 
	:medium_category_id, :subject_matter_id, :has_adult_content, 
	:software_used, :tags, :use_tag_from_previous_upload, :is_featured, 
	:status, :is_save_to_draft, :visibility, :publish, :company_logo, 
	:where_to_show, :images_attributes => [:id,:image,:imageable_id,:imageable_type, :_destroy,:tmp_image,:image_cache], :videos_attributes => [:id,:video,:videoable_id,:videoable_type, :_destroy,:tmp_image,:video_cache], :upload_videos_attributes => [:id,:uploadvideo,:uploadvideoable_id,:uploadvideoable_type, :_destroy,:tmp_image,:uploadvideo_cache], :sketchfebs_attributes => [:id,:sketchfeb,:sketchfebable_id,:sketchfebable_type, :_destroy,:tmp_sketchfeb,:sketchfeb_cache], :marmo_sets_attributes => [:id,:marmoset,:marmosetable_id,:marmosetable_type, :_destroy,:tmp_image,:marmoset_cache]

	form multipart: true do |f|
		
		f.inputs "Project" do
		  f.input :title
		  f.input :paramlink,label:'Permalink'
		  li do
			insert_tag(Arbre::HTML::Label, "Description", class: "label") { content_tag(:abbr, "*", title: "required") }
			f.bootsy_area :description, :rows => 15, :cols => 15, editor_options: { html: true }
		  end
		  f.input :post_type_category_id, as: :select, collection: Category.where("parent_id IS NULL ").pluck(:name, :id), include_blank: false, label: 'Post Type'
		  f.input :medium_category_id, as: :select, collection: MediumCategory.where("parent_id IS NULL ").pluck(:name, :id), include_blank: false, label: 'Medium'
		  f.input :subject_matter_id, as: :select, collection: SubjectMatter.where("parent_id IS NULL ").pluck(:name, :id), include_blank: false, label: 'Subject Matter'
		  f.input :has_adult_content, as: :select, collection: [['Yes',1],['No',0]], include_blank: false
		  f.input :software_used, label: 'Software used on this project'
		  f.input :tags, label:'Use Tags'
		  f.input :use_tag_from_previous_upload, as: :select, collection: [['Yes',1],['No',0]], include_blank: false
		  f.input :is_featured, as: :select, collection: [['Yes',1],['No',0]], include_blank: false, label: 'Feature this Post'
		  f.input :status, as: :select, collection: [['Active',1], ['Inactive', 0]], include_blank: false
		  f.input :is_save_to_draft, as: :select, collection: [['Yes',1], ['No', 0]], include_blank: false, label: 'Save Draft'
		  f.input :visibility, as: :select, collection: [['Private',1], ['Public', 0]], include_blank: false
		  f.input :publish, as: :select, collection: [['Yes',1], ['No', 0]], include_blank: false
		  f.input :company_logo,label: "Project Thumbnail"
			  
		  f.inputs 'Images' do
			f.has_many :images, allow_destroy: true, new_record: true do |ff|
			  ff.input :image, label: "Image", hint: ff.template.image_tag(ff.object.image.try(:url,:thumb))
			  ff.input :image_cache, :as => :hidden
			end
		  end	 
		  
		  f.inputs 'Add Video' do
			f.has_many :videos, allow_destroy: true, new_record: true do |ff|
			  ff.input :video, label: "Video"
			end
		  end	
		  
		 f.inputs 'Upload Video' do
			f.has_many :upload_videos, allow_destroy: true, new_record: true do |ff|
			  ff.input :uploadvideo, label: "Video", hint: ff.template.video_tag(ff.object.uploadvideo.try(:url), :size => "150x150")
			  ff.input :uploadvideo_cache, :as => :hidden
			end
		 end	
		 
		 f.inputs 'Sketchfeb' do
			f.has_many :sketchfebs, allow_destroy: true, new_record: true do |ff|
			  ff.input :sketchfeb, label: "Sketchfeb"
			end
		  end	
		
		f.inputs 'Marmoset' do
			f.has_many :marmo_sets, allow_destroy: true, new_record: true do |ff|
			  ff.input :marmoset, label: "Marmoset", hint: ff.template.video_tag(ff.object.marmoset.try(:url), :size => "150x150")
			  ff.input :marmoset_cache, :as => :hidden
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
			elsif (params[:gallery].present? && params[:gallery][:videos_attributes].present?)
					params[:gallery][:videos_attributes].each do |index,img|
						  unless params[:gallery][:videos_attributes][index][:video].present?
							params[:gallery][:videos_attributes][index][:video] = params[:gallery][:videos_attributes][index][:video_cache]
						  end
					end
				super
				
			elsif (params[:gallery].present? && params[:gallery][:upload_videos_attributes].present?)
					params[:gallery][:upload_videos_attributes].each do |index,img|
						  unless params[:gallery][:upload_videos_attributes][index][:uploadvideo].present?
							params[:gallery][:upload_videos_attributes][index][:uploadvideo] = params[:gallery][:upload_videos_attributes][index][:uploadvideo_cache]
						  end
					end
				super	
			elsif (params[:gallery].present? && params[:gallery][:sketchfebs_attributes].present?)
					params[:gallery][:sketchfebs_attributes].each do |index,img|
						  unless params[:gallery][:sketchfebs_attributes][index][:sketchfeb].present?
							params[:gallery][:sketchfebs_attributes][index][:sketchfeb] = params[:gallery][:sketchfebs_attributes][index][:sketchfeb_cache]
						  end
					end
				super
				
			elsif (params[:gallery].present? && params[:gallery][:marmosets_attributes].present?)
					params[:gallery][:marmosets_attributes].each do |index,img|
						  unless params[:gallery][:marmosets_attributes][index][:marmoset].present?
							params[:gallery][:marmosets_attributes][index][:marmoset] = params[:gallery][:marmosets_attributes][index][:marmoset_cache]
						  end
					end
				super
		  else
				super
		  end
		end

		def update
			
			if (params[:projects].present? && params[:projects][:images_attributes].present?)
				params[:projects][:images_attributes].each do |index,img|
					  unless params[:projects][:images_attributes][index][:image].present?
						params[:projects][:images_attributes][index][:image] = params[:projects][:images_attributes][index][:image_cache]
					  end
				end
				super
			elsif (params[:projects].present? && params[:projects][:videos_attributes].present?)
					params[:projects][:videos_attributes].each do |index,img|
						  unless params[:projects][:videos_attributes][index][:video].present?
							params[:projects][:videos_attributes][index][:video] = params[:projects][:videos_attributes][index][:video_cache]
						  end
					end
				super
			
			elsif (params[:projects].present? && params[:projects][:upload_videos_attributes].present?)
					params[:projects][:upload_videos_attributes].each do |index,img|
						  unless params[:projects][:upload_videos_attributes][index][:uploadvideo].present?
							params[:projects][:upload_videos_attributes][index][:uploadvideo] = params[:projects][:upload_videos_attributes][index][:uploadvideo_cache]
						  end
					end
				super	
			
			elsif (params[:projects].present? && params[:projects][:sketchfebs_attributes].present?)
					params[:projects][:sketchfebs_attributes].each do |index,img|
						  unless params[:projects][:sketchfebs_attributes][index][:sketchfeb].present?
							params[:projects][:sketchfebs_attributes][index][:sketchfeb] = params[:projects][:sketchfebs_attributes][index][:sketchfeb_cache]
						  end
					end
				super	
			
			elsif (params[:projects].present? && params[:projects][:marmosets_attributes].present?)
					params[:projects][:marmosets_attributes].each do |index,img|
						  unless params[:projects][:marmosets_attributes][index][:marmoset].present?
							params[:projects][:marmosets_attributes][index][:marmoset] = params[:projects][:marmosets_attributes][index][:marmoset_cache]
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
				if project.images.present?
				  project.images.each do |img|
					span do
					  image_tag(img.try(:image).try(:thumb).try(:url), class: "show-img")
					end
				  end
				end
			end
		  end
		  row 'Videos' do
			ul class: "image-blk" do
				if project.videos.present?
				  project.videos.each do |img|
					span do
						if img.video[/youtu\.be\/([^\?]*)/]
							youtube_id = $1
						  else
							img.video[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
							youtube_id = $5
						  end
						
						raw('<iframe title="Gallery Video" width="300" height="200" src="https://www.youtube.com/embed/' + youtube_id + '" frameborder="0" allowfullscreen></iframe>')
					
					end
				  end
				end
			end
		  end
		  
		  row 'Uploaded Videos' do
			ul class: "image-blk" do
				if project.upload_videos.present?
				  project.upload_videos.each do |img|
					span do
						raw('<iframe title="Gallery Video" width="300" height="200" src="'+img.uploadvideo.url+'" frameborder="0" allowfullscreen></iframe>')
					
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
