ActiveAdmin.register Tutorial do

   # menu label: 'Tutorial' , parent: 'Tutorial'
     menu false
    permit_params :title, {:topic => []} , {:sub_sub_topic => []}, {:sub_topic => []}, :user_id,:is_admin,:paramlink, {:challenge => []}, :show_on_cgmeetup,:show_on_website, :schedule_time, :description, {:software_used => []} , :tags, :is_featured, :status, :skill_level, :language, :free, :include_description, :total_lecture, :is_paid, :price, :is_save_to_draft, :visibility, :publish, :company_logo, :sub_title,  {:where_to_show => []} , :media_contents_attributes => [:id,:mediacontent,:media_caption,:mediacontentable_id,:mediacontentable_type, :_destroy, :tmp_mediacontent, :mediacontent_cache, :video_duration, :description, :media_type], :tags_attributes => [:id,:tag,:tagable_id,:tagable_type, :_destroy,:tmp_tag,:tag_cache],  :chapters_attributes => [:id,:title,:tutorial_id]
		
	collection_action :get_sub_topic, method: :get do
		ids		 =	params[:id]

		category = TutorialSubject.where("parent_id IS NULL AND topic_id IN (?)", ids).order('name asc').pluck(:name, :id)
		render json: category, status: 200
	end

	collection_action :get_sub_sub_topic, method: :get do
		ids			 =	params[:id]
		category 	 = TutorialSubject.where("parent_id IN (?)", ids).order('name asc').pluck(:name, :id)
		render json: category, status: 200
	end
	
	
	
	 controller do 

		def action_methods
		  super                                  
				if current_admin_user.id.to_s == '1'
					super
		  else
				usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
				disallowed = []
				disallowed << 'index' if (!usergroup.has_permission('tutorial_read') && !usergroup.has_permission('tutorial_write') && !usergroup.has_permission('tutorial_delete'))
				disallowed << 'delete' unless (usergroup.has_permission('tutorial_delete'))
				disallowed << 'create' unless (usergroup.has_permission('tutorial_write'))
				disallowed << 'new' unless (usergroup.has_permission('tutorial_write'))
				disallowed << 'edit' unless (usergroup.has_permission('tutorial_write'))
				disallowed << 'destroy' unless (usergroup.has_permission('tutorial_delete'))
			
				super - disallowed
		  end
		end
	  end
	
		
	form multipart: true do |f|

		f.inputs "Tutorial" do
		  f.input :title
		/   li do
			insert_tag(Arbre::HTML::Label, "Description", class: "label") { content_tag(:abbr, "*", title: "required") }
			f.bootsy_area :description, :rows => 15, :cols => 15, editor_options: { html: true }
		  end /
		  f.input :paramlink
		  div do
			f.input :description,  :input_html => { :class => "tinymce" }, :rows => 40, :cols => 50 ,label: false
		  end
		  
		  f.input :topic, as: :select, collection: Topic.where("parent_id IS NULL").pluck(:name, :id), :input_html => { :class => "chosen-input" }, include_blank: false,multiple: true ,label: 'Topic'
		
		  f.input :sub_topic, as: :select, collection: TutorialSubject.where("topic_id IS NOT NULL AND parent_id IS NULL").pluck(:name, :id), :input_html => { :class => "chosen-input" }, include_blank: false,multiple: true ,label: 'Subject'
		  f.input :sub_sub_topic, as: :select, collection: TutorialSubject.where("parent_id IS NOT NULL").pluck(:name, :id), :input_html => { :class => "chosen-input" }, include_blank: false,multiple: true ,label: 'Sub Subject'
		  
		 
		  f.input :software_used, as: :select, collection: SoftwareExpertise.where("id IS NOT NULL").pluck(:name, :id), :input_html => { :class => "chosen-input" }, include_blank: false,multiple: true 
		 # f.input :tags, label:'Tags'
		  f.input :skill_level, as: :select, collection: TutorialSkill.where("id IS NOT NULL").pluck(:title, :id), include_blank: false, label: 'Select Skill Level'
		  f.input :language, label:'Language'
		  f.input :include_description, label:'Include'
		  f.input :total_lecture, label:'No of Lecture'
		 
		  f.input :is_featured, as: :boolean,label: "Feature this Post"
		  f.input :free, as: :boolean,label: "Share for free"
		 # f.input :is_paid, as: :boolean,label: "Is Paid"
		  f.input :price, label: "Price ($)"
		  f.input :status, as: :select, collection: [['Active',1], ['Inactive', 0]], include_blank: false
		  f.input :is_save_to_draft, as: :select, collection: [['Yes',1], ['No', 0]], include_blank: false, label: 'Save Draft'
		  f.input :visibility, as: :select, collection: [['Private',1], ['Public', 0]], include_blank: false
		  f.input :publish, as: :select, collection: [['Immediately',1], ['Schedule', 0]], include_blank: false
		  f.input :schedule_time, as: :date_time_picker
		  f.input :company_logo,label: "Custom Thumbnail"
		  f.input :sub_title,label: "Sub Title"
		  f.input :challenge, as: :select, collection: Challenge.where("challenge_type_id = 1").pluck(:title, :id), :input_html => { :class => "chosen-input" }, include_blank: false, multiple: true
		
		  f.input :show_on_cgmeetup, as: :boolean,label: "Show On CGmeetup"
		  f.input :show_on_website, as: :boolean,label: "Show On Website"
			  
		  f.inputs 'Tags' do
			f.has_many :tags, allow_destroy: true, new_record: true do |ff|
			  ff.input :tag
			 # ff.input :tag_cache, :as => :hidden
			end 
		  end	
		  	  
		/	  
		  f.inputs 'Images' do
			f.has_many :images, allow_destroy: true, new_record: true do |ff|
			  ff.input :image, label: "Image", hint: ff.template.image_tag(ff.object.image.try(:url,:thumb))
			  ff.input :image_cache, :as => :hidden
			  ff.input :caption_image
			end 
		  end	 
		  
		  f.inputs 'Add Video' do
			f.has_many :videos, allow_destroy: true, new_record: true do |ff|
			  ff.input :video, label: "Video"
			  ff.input :caption_video
			end
		  end	
		  
		 f.inputs 'Upload Video' do
			f.has_many :upload_videos, allow_destroy: true, new_record: true do |ff|
			  ff.input :uploadvideo, label: "Video", hint: ff.template.video_tag(ff.object.uploadvideo.try(:url), :size => "150x150")
			  ff.input :uploadvideo_cache, :as => :hidden
			  ff.input :caption_upload_video
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
		 
		 f.inputs 'Upload Zip files' do
			f.has_many :zip_files, allow_destroy: true, new_record: true do |ff|
			  ff.input :zipfile, label: "Zip file", hint: ff.object.zipfile.try(:url)
			  ff.input :zip_caption, label: "Caption"
			  ff.input :zipfile_cache, :as => :hidden
			end
		 end	

	 
		 f.inputs 'Lessons' do
			f.has_many :media_contents, allow_destroy: true, new_record: true do |ff|
			  ff.input :lesson_video, label: "Lesson Video", hint: ff.template.video_tag(ff.object.lesson_video.try(:url), :size => "150x150")
			  ff.input :lesson_video_link, label: "Lesson Video Link (if exist)"
			  ff.input :lesson_title
			  ff.input :lesson_image, label: "Lesson Thumbnail"
			  ff.input :lesson_description
			 
			  
			  ff.input :lesson_video_cache, :as => :hidden
			end
		 end	/
		 
		
	 end
		
		
	f.actions
  end
  
   controller do

   	def get_rendom_password
			random_password = ([*'A'..'Z'] + [*'a'..'z'] + [*'0'..'9']).shuffle.take(10).join
   			result 			= Tutorial.where('tutorial_id = ?', random_password).count

            if result == 0
                return random_password
            else
                
                get_rendom_password
            end  


   		end	


	  def create
	  
			params[:tutorial][:user_id] = current_admin_user.id.to_s
			params[:tutorial][:is_admin] = 'Y'
			
			if params[:tutorial][:free] == '1'
				params[:tutorial][:price] = 0
			end

			random_password 			    = get_rendom_password
			params[:tutorial][:tutorial_id] = random_password

			
			if (params[:tutorial].present? && params[:tutorial][:images_attributes].present?)
					params[:tutorial][:images_attributes].each do |index,img|
						  unless params[:tutorial][:images_attributes][index][:image].present?
							#params[:tutorial][:images_attributes][index][:image] = params[:tutorial][:images_attributes][index][:image_cache]
							#params[:tutorial][:images_attributes][index][:caption_image] = params[:tutorial][:images_attributes][index][:caption_image]
						  end
					end
				super
			
			elsif (params[:tutorial].present? && params[:tutorial][:videos_attributes].present?)
					params[:tutorial][:videos_attributes].each do |index,img|
						  unless params[:tutorial][:videos_attributes][index][:video].present?
							#params[:tutorial][:videos_attributes][index][:video] = params[:tutorial][:videos_attributes][index][:video_cache]
							#params[:tutorial][:videos_attributes][index][:caption_video] = params[:tutorial][:videos_attributes][index][:caption_video]
						  end
					end
				super
				
				
			elsif (params[:tutorial].present? && params[:tutorial][:upload_videos_attributes].present?)
					params[:tutorial][:upload_videos_attributes].each do |index,img|
						  unless params[:tutorial][:upload_videos_attributes][index][:uploadvideo].present?
							#params[:tutorial][:upload_videos_attributes][index][:uploadvideo] = params[:tutorial][:upload_videos_attributes][index][:uploadvideo_cache]
							#params[:tutorial][:upload_videos_attributes][index][:caption_upload_video] = params[:tutorial][:upload_videos_attributes][index][:caption_upload_video]
						  end
					end
				super	
				
				
			elsif (params[:tutorial].present? && params[:tutorial][:sketchfebs_attributes].present?)
					params[:tutorial][:sketchfebs_attributes].each do |index,img|
						  unless params[:tutorial][:sketchfebs_attributes][index][:sketchfeb].present?
							#params[:tutorial][:sketchfebs_attributes][index][:sketchfeb] = params[:tutorial][:sketchfebs_attributes][index][:sketchfeb_cache]
						  end
					end
				super
				
			elsif (params[:tutorial].present? && params[:tutorial][:marmosets_attributes].present?)
					params[:tutorial][:marmosets_attributes].each do |index,img|
						  unless params[:tutorial][:marmosets_attributes][index][:marmoset].present?
							#params[:tutorial][:marmosets_attributes][index][:marmoset] = params[:tutorial][:marmosets_attributes][index][:marmoset_cache]
						  end
					end
				super
				
			elsif (params[:tutorial].present? && params[:tutorial][:lessons_attributes].present?)
					params[:tutorial][:lessons_attributes].each do |index,img|
						  unless params[:tutorial][:lessons_attributes][index][:lesson_title].present?
							#params[:tutorial][:lessons_attributes][index][:lesson_title] = params[:tutorial][:lessons_attributes][index][:lesson_title]
							#params[:tutorial][:lessons_attributes][index][:lesson_video_link] = params[:tutorial][:lessons_attributes][index][:lesson_video_link]
							#params[:tutorial][:lessons_attributes][index][:lesson_video] = params[:tutorial][:lessons_attributes][index][:lesson_video]
							#params[:tutorial][:lessons_attributes][index][:lesson_description] = params[:tutorial][:lessons_attributes][index][:lesson_description]
							#params[:tutorial][:lessons_attributes][index][:lesson_image] = params[:tutorial][:lessons_attributes][index][:lesson_image]
						  end
					end
				super	
				
			elsif (params[:tutorial].present? && params[:tutorial][:zip_files_attributes].present?)
					params[:tutorial][:zip_files_attributes].each do |index,img|
						  unless params[:tutorial][:zip_files_attributes][index][:zipfile].present?
							#params[:tutorial][:zip_files_attributes][index][:zipfile] = params[:tutorial][:zip_files_attributes][index][:zipfile_cache]
							#params[:tutorial][:zip_files_attributes][index][:zip_caption] = params[:tutorial][:zip_files_attributes][index][:zip_caption]
						
						  end
					end
			super
				
				
		  else
				super
		  end
		end

		def update
		#abort(current_admin_user.id.to_s)
			params[:tutorial][:user_id] = current_admin_user.id.to_s
			params[:tutorial][:is_admin] = 'Y'
			
			if params[:tutorial][:free] == '1'
				params[:tutorial][:price] = 0
			end
			
			if (params[:tutorial].present? && params[:tutorial][:images_attributes].present?)
					params[:tutorial][:images_attributes].each do |index,img|
						  unless params[:tutorial][:images_attributes][index][:image].present?
							#params[:tutorial][:images_attributes][index][:image]  = params[:tutorial][:images_attributes][index][:image_cache]
						  end
					#params[:tutorial][:images_attributes][index][:caption_image]  = params[:tutorial][:images_attributes][index][:caption_image]
			
				end
			super
		
			elsif (params[:tutorial].present? && params[:tutorial][:videos_attributes].present?)
					params[:tutorial][:videos_attributes].each do |index,img|
						  unless params[:tutorial][:videos_attributes][index][:video].present?
							#params[:tutorial][:videos_attributes][index][:video] = params[:tutorial][:videos_attributes][index][:video_cache]
						  end
					#params[:tutorial][:videos_attributes][index][:caption_video]  = params[:tutorial][:videos_attributes][index][:caption_video]	  
					end
				super
			
			elsif (params[:tutorial].present? && params[:tutorial][:upload_videos_attributes].present?)
					params[:tutorial][:upload_videos_attributes].each do |index,img|
						  unless params[:tutorial][:upload_videos_attributes][index][:uploadvideo].present?
						#	params[:tutorial][:upload_videos_attributes][index][:uploadvideo] = params[:tutorial][:upload_videos_attributes][index][:uploadvideo_cache]
						  end
					#params[:tutorial][:upload_videos_attributes][index][:uploadvideo]  = params[:tutorial][:upload_videos_attributes][index][:uploadvideo]	  
					end
				super	
			
			elsif (params[:tutorial].present? && params[:tutorial][:sketchfebs_attributes].present?)
					params[:tutorial][:sketchfebs_attributes].each do |index,img|
						  unless params[:tutorial][:sketchfebs_attributes][index][:sketchfeb].present?
							#params[:tutorial][:sketchfebs_attributes][index][:sketchfeb] = params[:tutorial][:sketchfebs_attributes][index][:sketchfeb_cache]
						  end
					end
				super	
			
			elsif (params[:tutorial].present? && params[:tutorial][:marmosets_attributes].present?)
					params[:tutorial][:marmosets_attributes].each do |index,img|
						  unless params[:tutorial][:marmosets_attributes][index][:marmoset].present?
							#params[:tutorial][:marmosets_attributes][index][:marmoset] = params[:tutorial][:marmosets_attributes][index][:marmoset_cache]
						  end
					end
				super	
				
			elsif (params[:tutorial].present? && params[:tutorial][:lessons_attributes].present?)
					params[:tutorial][:lessons_attributes].each do |index,img|
						  unless params[:tutorial][:lessons_attributes][index][:lesson_title].present?
							#params[:tutorial][:lessons_attributes][index][:lesson_title] = params[:tutorial][:lessons_attributes][index][:lesson_title]
							#params[:tutorial][:lessons_attributes][index][:lesson_video_link] = params[:tutorial][:lessons_attributes][index][:lesson_video_link]
							#params[:tutorial][:lessons_attributes][index][:lesson_video] = params[:tutorial][:lessons_attributes][index][:lesson_video]
							#params[:tutorial][:lessons_attributes][index][:lesson_description] = params[:tutorial][:lessons_attributes][index][:lesson_description]
							#params[:tutorial][:lessons_attributes][index][:lesson_image] = params[:tutorial][:lessons_attributes][index][:lesson_image]
						  end
					end
				super
			
			elsif (params[:tutorial].present? && params[:tutorial][:zip_files_attributes].present?)
					params[:tutorial][:zip_files_attributes].each do |index,img|
						  unless params[:tutorial][:zip_files_attributes][index][:zipfile].present?
							#params[:tutorial][:zip_files_attributes][index][:zipfile] = params[:tutorial][:zip_files_attributes][index][:zipfile_cache]
							#params[:tutorial][:zip_files_attributes][index][:zip_caption] = params[:tutorial][:zip_files_attributes][index][:zip_caption]
						
						  end
					end
			super	
						
				
				
		 else
				super
		  end
		  
		end
			
  end
  
  
  filter :title
  filter :status, as: :select, collection: [['Active',1], ['Inactive', 0]], label: 'Status'
  filter :is_featured, as: :select, collection: [['Yes',1], ['No', 0]], label: 'Featured'
  filter :created_at

	
	
     # Users List View
  index :download_links => ['csv'] do
	   selectable_column
	   column 'Image' do |img|
		  image_tag img.try(:company_logo).try(:url, :thumb), height: 50, width: 50
	   end
	   column 'Username' do |uname|
			(uname.user_id == 1 && uname.is_admin == 'Y') ? 'Admin' : User.find_by(id: uname.user_id).try(:firstname)
		end
	   column 'title' 
	   column 'Featured' do |feature|
			(feature.is_featured == true) ? 'Yes' : 'No'
	   end
		column "Paramlink", :paramlink

	   column 'Status' do |user|
		  user.status? ? 'Active' : 'Inactive'
		end
		actions
  end	
  
  
  show do
		attributes_table do
		  row :title
		#  row :description
		  row 'Description' do |cat|
			cat.description.html_safe
		  end
		
		  row :is_featured do |ifeature|
		   (ifeature.is_featured == true) ? 'Yes' : 'No'
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
		  
		 
	
		  row :created_at
		end
    end
  
  csv do
		column :title
		column 'Description' do |cat|
			cat.description.html_safe
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
  
  batch_action "Update Status for", form: { status: [['Active',1],['Inactive',0]] } do |ids, inputs|    
		Tutorial.where(id: ids).update_all(status: inputs[:status])
		redirect_to collection_path, notice: "Status has successfully changed"
 end
  
  


end
