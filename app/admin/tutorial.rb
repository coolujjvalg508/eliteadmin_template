ActiveAdmin.register Tutorial do

    menu label: 'Tutorial' , parent: 'Tutorial', priority: 1
    
    permit_params :title, :topic, :user_id,:is_admin, {:challenge => {}}, {:topic => []}, {:sub_topic => []}, :show_on_cgmeetup,:show_on_website, :schedule_time, :description, {:software_used => []} , :tags, :is_featured, :status, :skill_level, :language, :free, :include_description, :total_lecture, :is_paid, :price, :is_save_to_draft, :visibility, :publish, :company_logo, :sub_title,  {:where_to_show => []} , :images_attributes => [:id,:image,:caption_image,:imageable_id,:imageable_type, :_destroy,:tmp_image,:image_cache], :videos_attributes => [:id,:video,:caption_video,:videoable_id,:videoable_type, :_destroy,:tmp_image,:video_cache], :upload_videos_attributes => [:id,:uploadvideo,:caption_upload_video,:uploadvideoable_id,:uploadvideoable_type, :_destroy,:tmp_image,:uploadvideo_cache], :sketchfebs_attributes => [:id,:sketchfeb,:sketchfebable_id,:sketchfebable_type, :_destroy,:tmp_sketchfeb,:sketchfeb_cache], :marmo_sets_attributes => [:id,:marmoset,:marmosetable_id,:marmosetable_type, :_destroy,:tmp_marmoset,:marmoset_cache], :lessons_attributes => [:id,:lesson_title, :lesson_video, :lesson_video_link, :lessonable_id,:lessonable_type, :_destroy,:tmp_lesson,:lesson_video_cache, :lesson_description,:lesson_image],:zip_files_attributes => [:id,:zipfile, :zipfileable_id,:zipfileable_type, :_destroy,:tmp_zipfile,:zipfile_cache,:zip_caption],:tags_attributes => [:id,:tag,:tagable_id,:tagable_type, :_destroy,:tmp_tag,:tag_cache]
		
	collection_action :get_sub_topic, method: :get do
		ids		 =	params[:id]
		category = Topic.where(parent_id: ids).order('name asc').pluck(:name, :id)
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
		  div do
			f.input :description,  :input_html => { :class => "tinymce" }, :rows => 40, :cols => 50 ,label: false
		  end
		  
		  f.input :topic, as: :select, collection: Topic.where("parent_id IS NULL").pluck(:name, :id), :input_html => { :class => "chosen-input" }, include_blank: false,multiple: true ,label: 'Topic'
		
		  f.input :sub_topic, as: :select, collection: Topic.where("parent_id IS NOT NULL").pluck(:name, :id), :input_html => { :class => "chosen-input" }, include_blank: false,multiple: true ,label: 'Sub Topic'
		 
		  f.input :software_used, as: :select, collection: SoftwareExpertise.where("id IS NOT NULL").pluck(:name, :id), :input_html => { :class => "chosen-input" }, include_blank: false,multiple: true 
		 # f.input :tags, label:'Tags'
		  f.input :skill_level, as: :select, collection: Tutorial::SKILL_LEVEL, include_blank: false, label: 'Select Skill Level'
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
			f.has_many :lessons, allow_destroy: true, new_record: true do |ff|
			  ff.input :lesson_video, label: "Lesson Video", hint: ff.template.video_tag(ff.object.lesson_video.try(:url), :size => "150x150")
			  ff.input :lesson_video_link, label: "Lesson Video Link (if exist)"
			  ff.input :lesson_title
			  ff.input :lesson_image, label: "Lesson Thumbnail"
			  ff.input :lesson_description
			 
			  
			  ff.input :lesson_video_cache, :as => :hidden
			end
		 end	
		 
		
	 end
		
		
	f.actions
  end
  
   controller do
	  def create
	  
			params[:tutorial][:user_id] = current_admin_user.id.to_s
			params[:tutorial][:is_admin] = 'Y'
			
			if params[:tutorial][:free] == '1'
				params[:tutorial][:price] = 0
			end
			
			if (params[:tutorial].present? && params[:tutorial][:images_attributes].present?)
					params[:tutorial][:images_attributes].each do |index,img|
						  unless params[:tutorial][:images_attributes][index][:image].present?
							params[:tutorial][:images_attributes][index][:image] = params[:tutorial][:images_attributes][index][:image_cache]
							params[:tutorial][:images_attributes][index][:caption_image] = params[:tutorial][:images_attributes][index][:caption_image]
						  end
					end
				super
			
			elsif (params[:tutorial].present? && params[:tutorial][:videos_attributes].present?)
					params[:tutorial][:videos_attributes].each do |index,img|
						  unless params[:tutorial][:videos_attributes][index][:video].present?
							params[:tutorial][:videos_attributes][index][:video] = params[:tutorial][:videos_attributes][index][:video_cache]
							params[:tutorial][:videos_attributes][index][:caption_video] = params[:tutorial][:videos_attributes][index][:caption_video]
						  end
					end
				super
				
				
			elsif (params[:tutorial].present? && params[:tutorial][:upload_videos_attributes].present?)
					params[:tutorial][:upload_videos_attributes].each do |index,img|
						  unless params[:tutorial][:upload_videos_attributes][index][:uploadvideo].present?
							params[:tutorial][:upload_videos_attributes][index][:uploadvideo] = params[:tutorial][:upload_videos_attributes][index][:uploadvideo_cache]
							params[:tutorial][:upload_videos_attributes][index][:caption_upload_video] = params[:tutorial][:upload_videos_attributes][index][:caption_upload_video]
						  end
					end
				super	
				
				
			elsif (params[:tutorial].present? && params[:tutorial][:sketchfebs_attributes].present?)
					params[:tutorial][:sketchfebs_attributes].each do |index,img|
						  unless params[:tutorial][:sketchfebs_attributes][index][:sketchfeb].present?
							params[:tutorial][:sketchfebs_attributes][index][:sketchfeb] = params[:tutorial][:sketchfebs_attributes][index][:sketchfeb_cache]
						  end
					end
				super
				
			elsif (params[:tutorial].present? && params[:tutorial][:marmosets_attributes].present?)
					params[:tutorial][:marmosets_attributes].each do |index,img|
						  unless params[:tutorial][:marmosets_attributes][index][:marmoset].present?
							params[:tutorial][:marmosets_attributes][index][:marmoset] = params[:tutorial][:marmosets_attributes][index][:marmoset_cache]
						  end
					end
				super
				
			elsif (params[:tutorial].present? && params[:tutorial][:lessons_attributes].present?)
					params[:tutorial][:lessons_attributes].each do |index,img|
						  unless params[:tutorial][:lessons_attributes][index][:lesson_title].present?
							params[:tutorial][:lessons_attributes][index][:lesson_title] = params[:tutorial][:lessons_attributes][index][:lesson_title]
							params[:tutorial][:lessons_attributes][index][:lesson_video_link] = params[:tutorial][:lessons_attributes][index][:lesson_video_link]
							params[:tutorial][:lessons_attributes][index][:lesson_video] = params[:tutorial][:lessons_attributes][index][:lesson_video]
							params[:tutorial][:lessons_attributes][index][:lesson_description] = params[:tutorial][:lessons_attributes][index][:lesson_description]
							params[:tutorial][:lessons_attributes][index][:lesson_image] = params[:tutorial][:lessons_attributes][index][:lesson_image]
						  end
					end
				super	
				
			elsif (params[:tutorial].present? && params[:tutorial][:zip_files_attributes].present?)
					params[:tutorial][:zip_files_attributes].each do |index,img|
						  unless params[:tutorial][:zip_files_attributes][index][:zipfile].present?
							params[:tutorial][:zip_files_attributes][index][:zipfile] = params[:tutorial][:zip_files_attributes][index][:zipfile_cache]
							params[:tutorial][:zip_files_attributes][index][:zip_caption] = params[:tutorial][:zip_files_attributes][index][:zip_caption]
						
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
							params[:tutorial][:images_attributes][index][:image]  = params[:tutorial][:images_attributes][index][:image_cache]
						  end
					params[:tutorial][:images_attributes][index][:caption_image]  = params[:tutorial][:images_attributes][index][:caption_image]
			
				end
			super
		
			elsif (params[:tutorial].present? && params[:tutorial][:videos_attributes].present?)
					params[:tutorial][:videos_attributes].each do |index,img|
						  unless params[:tutorial][:videos_attributes][index][:video].present?
							params[:tutorial][:videos_attributes][index][:video] = params[:tutorial][:videos_attributes][index][:video_cache]
						  end
					params[:tutorial][:videos_attributes][index][:caption_video]  = params[:tutorial][:videos_attributes][index][:caption_video]	  
					end
				super
			
			elsif (params[:tutorial].present? && params[:tutorial][:upload_videos_attributes].present?)
					params[:tutorial][:upload_videos_attributes].each do |index,img|
						  unless params[:tutorial][:upload_videos_attributes][index][:uploadvideo].present?
							params[:tutorial][:upload_videos_attributes][index][:uploadvideo] = params[:tutorial][:upload_videos_attributes][index][:uploadvideo_cache]
						  end
					params[:tutorial][:upload_videos_attributes][index][:uploadvideo]  = params[:tutorial][:upload_videos_attributes][index][:uploadvideo]	  
					end
				super	
			
			elsif (params[:tutorial].present? && params[:tutorial][:sketchfebs_attributes].present?)
					params[:tutorial][:sketchfebs_attributes].each do |index,img|
						  unless params[:tutorial][:sketchfebs_attributes][index][:sketchfeb].present?
							params[:tutorial][:sketchfebs_attributes][index][:sketchfeb] = params[:tutorial][:sketchfebs_attributes][index][:sketchfeb_cache]
						  end
					end
				super	
			
			elsif (params[:tutorial].present? && params[:tutorial][:marmosets_attributes].present?)
					params[:tutorial][:marmosets_attributes].each do |index,img|
						  unless params[:tutorial][:marmosets_attributes][index][:marmoset].present?
							params[:tutorial][:marmosets_attributes][index][:marmoset] = params[:tutorial][:marmosets_attributes][index][:marmoset_cache]
						  end
					end
				super	
				
			elsif (params[:tutorial].present? && params[:tutorial][:lessons_attributes].present?)
					params[:tutorial][:lessons_attributes].each do |index,img|
						  unless params[:tutorial][:lessons_attributes][index][:lesson_title].present?
							params[:tutorial][:lessons_attributes][index][:lesson_title] = params[:tutorial][:lessons_attributes][index][:lesson_title]
							params[:tutorial][:lessons_attributes][index][:lesson_video_link] = params[:tutorial][:lessons_attributes][index][:lesson_video_link]
							params[:tutorial][:lessons_attributes][index][:lesson_video] = params[:tutorial][:lessons_attributes][index][:lesson_video]
							params[:tutorial][:lessons_attributes][index][:lesson_description] = params[:tutorial][:lessons_attributes][index][:lesson_description]
							params[:tutorial][:lessons_attributes][index][:lesson_image] = params[:tutorial][:lessons_attributes][index][:lesson_image]
						  end
					end
				super
			
			elsif (params[:tutorial].present? && params[:tutorial][:zip_files_attributes].present?)
					params[:tutorial][:zip_files_attributes].each do |index,img|
						  unless params[:tutorial][:zip_files_attributes][index][:zipfile].present?
							params[:tutorial][:zip_files_attributes][index][:zipfile] = params[:tutorial][:zip_files_attributes][index][:zipfile_cache]
							params[:tutorial][:zip_files_attributes][index][:zip_caption] = params[:tutorial][:zip_files_attributes][index][:zip_caption]
						
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
		  row :topic do |cat|
		    Topic.find_by(id: cat.topic).try(:name)
		  end
		  row :tags

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
		  
		  row 'Images' do
			ul class: "image-blk" do
				if tutorial.images.present?
				  tutorial.images.each do |img|
					span do
					  image_tag(img.try(:image).try(:thumb).try(:url), class: "show-img")
					end
				  end
				end
			end
		  end
		  row 'Videos' do
			ul class: "image-blk" do
				if tutorial.videos.present?
					tutorial.videos.each do |img|
						span do
								if(img.video.include?('youtube'))	
										if img.video[/youtu\.be\/([^\?]*)/]
											youtube_id = $1
										  else
											img.video[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
											youtube_id = $5
										  end
										raw('<iframe title="Gallery Video" width="300" height="200" src="https://www.youtube.com/embed/' + youtube_id + '" frameborder="0" allowfullscreen></iframe>')
	
								 elsif(img.video.include?('vimeo'))	
											match = img.video.match(/https?:\/\/(?:[\w]+\.)*vimeo\.com(?:[\/\w]*\/?)?\/(?<id>[0-9]+)[^\s]*/)

											if match.present?
												vimeoid	=	match[:id]
											end
											raw('<iframe width="300" height="200" src="https://player.vimeo.com/video/'+vimeoid+'" width="640" height="270" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>')
							
								  elsif(img.video.include?('dailymotion'))	
											match =  img.video.gsub('http://www.dailymotion.com/video/', "")
											match1	= match.index('_')
											match	= match[0...match1]
											if match.present?
												dailymotionid	=	match
											end	
									
										raw('<iframe width="300" height="200" frameborder="0"  src="//www.dailymotion.com/embed/video/'+ dailymotionid +'" allowfullscreen></iframe>')	
							
								  end
						 end
					end
				end
			end
		  end
		  
		  row 'Uploaded Videos' do
			ul class: "image-blk" do
				if tutorial.upload_videos.present?
				  tutorial.upload_videos.each do |img|
					span do
						raw('<iframe title="Gallery Video" width="300" height="200" src="'+img.uploadvideo.url+'" frameborder="0" allowfullscreen></iframe>')
					
					end
				  end
				end
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
		column 'Topic' do |cat|
			Topic.find_by(id: cat.topic).try(:name)
		end
		column :tags
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
