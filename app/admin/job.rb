ActiveAdmin.register Job do
	menu label: 'Jobs', parent: 'Job Management',priority: 1
	permit_params :is_spam, :title,:user_id,:is_admin, :paramlink,{:package_id => []},:description,:show_on_cgmeetup,:show_on_website,:company_url, :company_id, :schedule_time, :job_type, :from_amount, :to_amount, {:job_category => []} , 
	:application_email_or_url, :country, :city, :state,
	:work_remotely, :relocation_asistance,:closing_date, {:skill => []} , {:software_expertise => []} , :tags, :use_tag_from_previous_upload, :is_featured, :status, :apply_type,:apply_instruction,:apply_email,:apply_url,:is_save_to_draft,:visibility,:publish,:company_logo, {:where_to_show => []} , :images_attributes => [:id,:image,:caption_image,:imageable_id,:imageable_type, :_destroy,:tmp_image,:image_cache], :videos_attributes => [:id,:video,:caption_video,:videoable_id,:videoable_type, :_destroy,:tmp_image,:video_cache], :upload_videos_attributes => [:id,:uploadvideo,:caption_upload_video,:uploadvideoable_id,:uploadvideoable_type, :_destroy,:tmp_image,:uploadvideo_cache], :sketchfebs_attributes => [:id,:sketchfeb,:sketchfebable_id,:sketchfebable_type, :_destroy,:tmp_sketchfeb,:sketchfeb_cache], :marmo_sets_attributes => [:id,:marmoset,:marmosetable_id,:marmosetable_type, :_destroy,:tmp_image,:marmoset_cache], :company_attributes => [:id,:name,:user_id], :zip_files_attributes => [:id,:zipfile, :zipfileable_id,:zipfileable_type, :_destroy,:tmp_zipfile,:zipfile_cache,:zip_caption],:tags_attributes => [:id,:tag,:tagable_id,:tagable_type, :_destroy,:tmp_tag,:tag_cache]
	
	collection_action :get_packages, method: :get do
		category = Package.where("id IS NOT NULL").order('id asc').pluck(:amount,:title, :id)
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
			disallowed << 'index' if (!usergroup.has_permission('job_read') && !usergroup.has_permission('job_write') && !usergroup.has_permission('job_delete'))
			disallowed << 'delete' unless (usergroup.has_permission('job_delete'))
			disallowed << 'create' unless (usergroup.has_permission('job_write'))
			disallowed << 'new' unless (usergroup.has_permission('job_write'))
			disallowed << 'edit' unless (usergroup.has_permission('job_write'))
			disallowed << 'destroy' unless (usergroup.has_permission('job_delete'))
			
			super - disallowed
		  end
		end
	  end
	
	
	
	
	form multipart: true do |f|
		
		f.inputs "Job" do
		
			f.input :package_id, as: :select, collection: Package.where("id IS NOT NULL").pluck(:title, :id), :input_html => { :id=>'job_package_id', :class => "chosen-input" }, include_blank:false,multiple: true
			
	  	  
		  f.input :title
		  f.input :paramlink,label:'Permalink'
		 / li do
			insert_tag(Arbre::HTML::Label, "Description", class: "label") { content_tag(:abbr, "*", title: "required") }
			f.bootsy_area :description, :rows => 15, :cols => 15, editor_options: { html: true }
		  end /
		  
		 div do
			f.input :description,  :input_html => { :class => "tinymce" }, :rows => 40, :cols => 50 ,label: false
		  end
		  
		  f.input :company_id, as: :select, collection: Company.where("name != '' ").pluck(:name, :id),include_blank:'Select Company Name'
		  if ((controller.action_name == 'new' || controller.action_name == 'create'))
			  f.inputs for: [:company, f.object.company || Company.new] do |company|
					company.input :name, label:'Company Name'
			  end
		  end
		  f.input :company_url, as: :string, label:'Company URL'
		   
		  f.input :job_type, as: :select, collection: JobCategory.where("id IS NOT NULL").pluck(:name, :id), include_blank:'Select Job Type'
		  f.input :from_amount, label:'From Amount'
		  f.input :to_amount, label:'To Amount'
		  f.input :job_category, as: :select, collection: CategoryType.where("id IS NOT NULL").pluck(:name, :id), :input_html => { :class => "chosen-input" }, include_blank: false, multiple: true,label: 'Job Position'
		  f.input :application_email_or_url,label:'Application Email/URL'
		  f.input :country,label:'Country', :input_html => { :class => "chosen-input" }
		  f.input :state,label:'State'
		  f.input :city,label:'City'
		 
		  f.input :work_remotely, as: :boolean,label: "Work Remotely"
		  f.input :relocation_asistance, as: :boolean,label: "Relocation Asistance"
		  
		  f.input :closing_date, as: :date_time_picker,label:'Closing Date'
		  f.input :skill, as: :select, collection: JobSkill.where("id IS NOT NULL").pluck(:name, :id), :input_html => { :class => "chosen-input" }, include_blank: false, multiple: true
		  f.input :software_expertise, as: :select, collection: SoftwareExpertise.where("id IS NOT NULL").pluck(:name, :id), :input_html => { :class => "chosen-input" }, include_blank: false,multiple: true 
		 # f.input :tags
		 
		  f.input :is_featured, as: :boolean,label: "Featured Job"
		  f.input :status, as: :select, collection: [['Active',1], ['Inactive', 0]], include_blank: false
		  f.input :is_save_to_draft, as: :select, collection: [['Yes',1], ['No', 0]], include_blank: false, label: 'Save Draft'
		  f.input :visibility, as: :select, collection: [['Public', 1], ['Private',0]], include_blank: false
		  f.input :publish, as: :select, collection: [['Immediately',1], ['Schedule', 0]], include_blank: false
		  f.input :schedule_time, as: :date_time_picker
		  f.input :company_logo,label: "Company logo"
		   # f.input :where_to_show, as: :select, collection: [['On CGmeetup',1],['On Website',0]], include_blank: false,multiple: true
		  f.input :show_on_cgmeetup, as: :boolean,label: "Show On CGmeetup"
		  f.input :show_on_website, as: :boolean,label: "Show On Website"
		  f.input :is_spam, as: :boolean,label: "Make Spam"
		   f.input :apply_type, as: :select, collection: [['Email', 'email'], ['URL','url'], ['Instruction','instruction']], include_blank: false,label:'How to Apply'
		  f.input :apply_email, label: "Apply by Email"
		  f.input :apply_url, label: "Apply by URL"
		  div do
			f.input :apply_instruction,  :input_html => { :class => "tinymce" }, :rows => 40, :cols => 50 ,label: "Application Instructions"
		  end
		
		   f.input :use_tag_from_previous_upload, as: :boolean,label: "Use Tag From Previous Upload"
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
		 
		f.inputs 'Upload Zip/Rar files' do
			f.has_many :zip_files, allow_destroy: true, new_record: true do |ff|
			  ff.input :zipfile, label: "Zip/Rar file", hint: ff.object.zipfile.try(:url)
			  ff.input :zip_caption, label: "Caption"
			  ff.input :zipfile_cache, :as => :hidden
			end
		 end
		 
		
	 end
		
		
	f.actions
  end

  controller do
	  def create
			params[:job][:user_id] = current_admin_user.id.to_s
			params[:job][:is_admin] = 'Y'
			if (params[:job].present? && params[:job][:images_attributes].present?)
					params[:job][:images_attributes].each do |index,img|
						  unless params[:job][:images_attributes][index][:image].present?
							params[:job][:images_attributes][index][:image] = params[:job][:images_attributes][index][:image_cache]
							params[:job][:images_attributes][index][:caption_image] = params[:job][:images_attributes][index][:caption_image]
						  end
					end
				super
			
			elsif (params[:job].present? && params[:job][:videos_attributes].present?)
					params[:job][:videos_attributes].each do |index,img|
						  unless params[:job][:videos_attributes][index][:video].present?
							params[:job][:videos_attributes][index][:video] = params[:job][:videos_attributes][index][:video_cache]
							params[:job][:videos_attributes][index][:caption_video] = params[:job][:videos_attributes][index][:caption_video]
						  end
					end
				super
				
				
			elsif (params[:job].present? && params[:job][:upload_videos_attributes].present?)
					params[:job][:upload_videos_attributes].each do |index,img|
						  unless params[:job][:upload_videos_attributes][index][:uploadvideo].present?
							params[:job][:upload_videos_attributes][index][:uploadvideo] = params[:job][:upload_videos_attributes][index][:uploadvideo_cache]
							params[:job][:upload_videos_attributes][index][:caption_upload_video] = params[:job][:upload_videos_attributes][index][:caption_upload_video]
						  end
					end
				super	
				
				
			elsif (params[:job].present? && params[:job][:sketchfebs_attributes].present?)
					params[:job][:sketchfebs_attributes].each do |index,img|
						  unless params[:job][:sketchfebs_attributes][index][:sketchfeb].present?
							params[:job][:sketchfebs_attributes][index][:sketchfeb] = params[:job][:sketchfebs_attributes][index][:sketchfeb_cache]
						  end
					end
				super
				
			elsif (params[:job].present? && params[:job][:marmosets_attributes].present?)
					params[:job][:marmosets_attributes].each do |index,img|
						  unless params[:job][:marmosets_attributes][index][:marmoset].present?
							params[:job][:marmosets_attributes][index][:marmoset] = params[:job][:marmosets_attributes][index][:marmoset_cache]
						  end
					end
				super
		  else
				super
		  end
		end

		def update
		#abort(params.to_json)
			params[:job][:user_id] = current_admin_user.id.to_s
			params[:job][:is_admin] = 'Y'
			if (params[:job].present? && params[:job][:images_attributes].present?)
					params[:job][:images_attributes].each do |index,img|
						  unless params[:job][:images_attributes][index][:image].present?
							params[:job][:images_attributes][index][:image]  = params[:job][:images_attributes][index][:image_cache]
						  end
					params[:job][:images_attributes][index][:caption_image]  = params[:job][:images_attributes][index][:caption_image]
			
				end
			super
		
			elsif (params[:job].present? && params[:job][:videos_attributes].present?)
					params[:job][:videos_attributes].each do |index,img|
						  unless params[:job][:videos_attributes][index][:video].present?
							params[:job][:videos_attributes][index][:video] = params[:job][:videos_attributes][index][:video_cache]
						  end
					params[:job][:videos_attributes][index][:caption_video]  = params[:job][:videos_attributes][index][:caption_video]	  
					end
				super
			
			elsif (params[:job].present? && params[:job][:upload_videos_attributes].present?)
					params[:job][:upload_videos_attributes].each do |index,img|
						  unless params[:job][:upload_videos_attributes][index][:uploadvideo].present?
							params[:job][:upload_videos_attributes][index][:uploadvideo] = params[:job][:upload_videos_attributes][index][:uploadvideo_cache]
						  end
					params[:job][:upload_videos_attributes][index][:uploadvideo]  = params[:job][:upload_videos_attributes][index][:uploadvideo]	  
					end
				super	
			
			elsif (params[:job].present? && params[:job][:sketchfebs_attributes].present?)
					params[:job][:sketchfebs_attributes].each do |index,img|
						  unless params[:job][:sketchfebs_attributes][index][:sketchfeb].present?
							params[:job][:sketchfebs_attributes][index][:sketchfeb] = params[:job][:sketchfebs_attributes][index][:sketchfeb_cache]
						  end
					end
				super	
			
			elsif (params[:job].present? && params[:job][:marmosets_attributes].present?)
					params[:job][:marmosets_attributes].each do |index,img|
						  unless params[:job][:marmosets_attributes][index][:marmoset].present?
							params[:job][:marmosets_attributes][index][:marmoset] = params[:job][:marmosets_attributes][index][:marmoset_cache]
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
	   column 'Title' do |title|
		 title.title
	   end
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
	
		  row :paramlink
		  row 'Description' do |cat|
			cat.description.html_safe
		  end
		  row :job_type do |utag|
		     JobCategory.find_by(id: utag.job_type).try(:name)
		  end
		  row :from_amount
		  row :to_amount
		
		  row :application_email_or_url
		  row :country do |utag|
		    utag.country? ? ISO3166::Country[utag.country] : '----'
		  end
		  
		  row :city
		  row :work_remotely do |ifeature|
		    ifeature.work_remotely? ? 'Yes' : 'No'
		  end
		  row :relocation_asistance do |ifeature|
		    ifeature.relocation_asistance? ? 'Yes' : 'No'
		  end

		  row :closing_date
		 
		  row :use_tag_from_previous_upload do |utag|
		    utag.use_tag_from_previous_upload? ? 'Yes' : 'No'
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
		    st.visibility? ? 'Public' : 'Private'
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
				if job.images.present?
				  job.images.each do |img|
					span do
					  image_tag(img.try(:image).try(:thumb).try(:url), class: "show-img")
					end
				  end
				end
			end
		  end
		  
		  row 'Videos' do
			ul class: "image-blk" do
				if job.videos.present?
					job.videos.each do |img|
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
				if job.upload_videos.present?
				  job.upload_videos.each do |img|
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
		column :paramlink
		column :company_name
		column :from_amount
		column :to_amount
		column :application_email_or_url

		
		column :job_type do |utag|
		     JobCategory.find_by(id: utag.job_type).try(:name)
		 end
		
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
   
     batch_action "Make Spam for", form: { is_spam: [['Yes',true],['No',false]] } do |ids, inputs|    
		Job.where(id: ids).update_all(is_spam: inputs[:is_spam])
		redirect_to collection_path, notice: "Job has successfully marked as spam"
	 end
	 
	 batch_action "Update Status for", form: { status: [['Active',1],['Inactive',0]] } do |ids, inputs|    
		Job.where(id: ids).update_all(status: inputs[:status])
		redirect_to collection_path, notice: "Status has successfully changed"
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
