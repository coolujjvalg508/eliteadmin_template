ActiveAdmin.register Challenge do

#	abort(current_admin_user.to_json)
	
    menu label: 'Challenge'
    
    permit_params :title, :upload_button_text, :hosts,:challenge_type_id, :closing_date, :team_member, :awards, :terms_condition, :faq, :user_id,:is_admin,  :schedule_time, :description, :status, :is_save_to_draft, :visibility, :publish, :company_logo,  {:where_to_show => []} , :images_attributes => [:id,:image,:caption_image,:imageable_id,:imageable_type, :_destroy,:tmp_image,:image_cache], :videos_attributes => [:id,:video,:caption_video,:videoable_id,:videoable_type, :_destroy,:tmp_image,:video_cache], :upload_videos_attributes => [:id,:uploadvideo,:caption_upload_video,:uploadvideoable_id,:uploadvideoable_type, :_destroy,:tmp_image,:uploadvideo_cache], :sketchfebs_attributes => [:id,:sketchfeb,:sketchfebable_id,:sketchfebable_type, :_destroy,:tmp_sketchfeb,:sketchfeb_cache], :marmo_sets_attributes => [:id,:marmoset,:marmosetable_id,:marmosetable_type, :_destroy,:tmp_image,:marmoset_cache],:tags_attributes => [:id,:tag,:tagable_id,:tagable_type, :_destroy,:tmp_tag,:tag_cache]
		
	
	
	 controller do 

		def action_methods
		  super                                  
				if current_admin_user.id.to_s == '1'
					super
		  else
				usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
				disallowed = []
				disallowed << 'index' if (!usergroup.has_permission('challenge_read') && !usergroup.has_permission('challenge_write') && !usergroup.has_permission('challenge_delete'))
				disallowed << 'delete' unless (usergroup.has_permission('challenge_delete'))
				disallowed << 'create' unless (usergroup.has_permission('challenge_write'))
				disallowed << 'new' unless (usergroup.has_permission('challenge_write'))
				disallowed << 'edit' unless (usergroup.has_permission('challenge_write'))
				disallowed << 'destroy' unless (usergroup.has_permission('challenge_delete'))
			
				super - disallowed
		  end
		end
	  end
	
	
		
		
	
	form multipart: true do |f|
		
		f.inputs "Challenge" do
		  f.input :title
		  div do
			f.input :description,  :input_html => { :class => "tinymce", :id=>"description_texteditor" }, :rows => 40, :cols => 50 ,label: 'Description'
		  end
		  f.input :upload_button_text
		   
		  f.input :challenge_type_id, as: :select, collection: [['Gallery Contest',0], ['Tutorial Contest', 1], ['Download Contest', 2]], include_blank: 'Select Challenge Type', label: 'Challenge Type'
		 
		  f.input :team_member,label:'Brought to you by'
		  f.input :hosts,label:'Hosts'
		  f.input :opening_date, as: :date_time_picker,label:'Starting Date'
		  f.input :closing_date, as: :date_time_picker, label:'Closing Date'
		 
		  div do
			f.input :awards,  :input_html => { :class => "tinymce", :id=>"awards_texteditor" }, :rows => 40, :cols => 50 ,label: 'Briefing'
		  end
		  div do
			f.input :terms_condition,  :input_html => { :class => "tinymce", :id=>"terms_texteditor" }, :rows => 40, :cols => 50 ,label: 'Challenge Rules'
		  end
		 / div do
			f.input :judging,  :input_html => { :class => "tinymce", :id=>"judging_texteditor" }, :rows => 40, :cols => 50 ,label: 'Judging'
		  end /
		  div do
			f.input :faq,  :input_html => { :class => "tinymce", :id=>"faq_texteditor" }, :rows => 40, :cols => 50 ,label: 'Frequently Asked Questions'
		  end

		  f.input :status, as: :select, collection: [['Active',1], ['Inactive', 0]], include_blank: false
		  f.input :is_save_to_draft, as: :select, collection: [['Yes',1], ['No', 0]], include_blank: false, label: 'Save Draft'
		  f.input :visibility, as: :select, collection: [['Private',1], ['Public', 0]], include_blank: false
		  f.input :publish, as: :select, collection: [['Immediately',1], ['Schedule', 0]], include_blank: false
		  f.input :schedule_time, as: :date_time_picker
		  f.input :company_logo,label: "Project Thumbnail"
		
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
		 
		
	 end
		
		
	f.actions
  end
  
  controller do
	  def create
			params[:challenge][:user_id] = current_admin_user.id.to_s
			params[:challenge][:is_admin] = 'Y'
			if (params[:challenge].present? && params[:challenge][:images_attributes].present?)
					params[:challenge][:images_attributes].each do |index,img|
						  unless params[:challenge][:images_attributes][index][:image].present?
							params[:challenge][:images_attributes][index][:image] = params[:challenge][:images_attributes][index][:image_cache]
							params[:challenge][:images_attributes][index][:caption_image] = params[:challenge][:images_attributes][index][:caption_image]
						  end
					end
				super
			
			elsif (params[:challenge].present? && params[:challenge][:videos_attributes].present?)
					params[:challenge][:videos_attributes].each do |index,img|
						  unless params[:challenge][:videos_attributes][index][:video].present?
							params[:challenge][:videos_attributes][index][:video] = params[:challenge][:videos_attributes][index][:video_cache]
							params[:challenge][:videos_attributes][index][:caption_video] = params[:challenge][:videos_attributes][index][:caption_video]
						  end
					end
				super
				
				
			elsif (params[:challenge].present? && params[:challenge][:upload_videos_attributes].present?)
					params[:challenge][:upload_videos_attributes].each do |index,img|
						  unless params[:challenge][:upload_videos_attributes][index][:uploadvideo].present?
							params[:challenge][:upload_videos_attributes][index][:uploadvideo] = params[:challenge][:upload_videos_attributes][index][:uploadvideo_cache]
							params[:challenge][:upload_videos_attributes][index][:caption_upload_video] = params[:challenge][:upload_videos_attributes][index][:caption_upload_video]
						  end
					end
				super	
				
				
			elsif (params[:challenge].present? && params[:challenge][:sketchfebs_attributes].present?)
					params[:challenge][:sketchfebs_attributes].each do |index,img|
						  unless params[:challenge][:sketchfebs_attributes][index][:sketchfeb].present?
							params[:challenge][:sketchfebs_attributes][index][:sketchfeb] = params[:challenge][:sketchfebs_attributes][index][:sketchfeb_cache]
						  end
					end
				super
				
			elsif (params[:challenge].present? && params[:challenge][:marmosets_attributes].present?)
					params[:challenge][:marmosets_attributes].each do |index,img|
						  unless params[:challenge][:marmosets_attributes][index][:marmoset].present?
							params[:challenge][:marmosets_attributes][index][:marmoset] = params[:challenge][:marmosets_attributes][index][:marmoset_cache]
						  end
					end
				super
				
			elsif (params[:challenge].present? && params[:challenge][:tags_attributes].present?)
					params[:challenge][:tags_attributes].each do |index,img|
						  unless params[:challenge][:tags_attributes][index][:tag].present?
							params[:challenge][:tags_attributes][index][:tag] = params[:challenge][:tags_attributes][index][:tag]
						  end
					end
				super	
				
		  else
				super
		  end
		end

		def update
		#abort(current_admin_user.id.to_s)
			params[:challenge][:user_id] = current_admin_user.id.to_s
			params[:challenge][:is_admin] = 'Y'
			if (params[:challenge].present? && params[:challenge][:images_attributes].present?)
					params[:challenge][:images_attributes].each do |index,img|
						  unless params[:challenge][:images_attributes][index][:image].present?
							params[:challenge][:images_attributes][index][:image]  = params[:challenge][:images_attributes][index][:image_cache]
						  end
					params[:challenge][:images_attributes][index][:caption_image]  = params[:challenge][:images_attributes][index][:caption_image]
			
				end
			super
		
			elsif (params[:challenge].present? && params[:challenge][:videos_attributes].present?)
					params[:challenge][:videos_attributes].each do |index,img|
						  unless params[:challenge][:videos_attributes][index][:video].present?
							params[:challenge][:videos_attributes][index][:video] = params[:challenge][:videos_attributes][index][:video_cache]
						  end
					params[:challenge][:videos_attributes][index][:caption_video]  = params[:challenge][:videos_attributes][index][:caption_video]	  
					end
				super
			
			elsif (params[:challenge].present? && params[:challenge][:upload_videos_attributes].present?)
					params[:challenge][:upload_videos_attributes].each do |index,img|
						  unless params[:challenge][:upload_videos_attributes][index][:uploadvideo].present?
							params[:challenge][:upload_videos_attributes][index][:uploadvideo] = params[:challenge][:upload_videos_attributes][index][:uploadvideo_cache]
						  end
					params[:challenge][:upload_videos_attributes][index][:uploadvideo]  = params[:challenge][:upload_videos_attributes][index][:uploadvideo]	  
					end
				super	
			
			elsif (params[:challenge].present? && params[:challenge][:sketchfebs_attributes].present?)
					params[:challenge][:sketchfebs_attributes].each do |index,img|
						  unless params[:challenge][:sketchfebs_attributes][index][:sketchfeb].present?
							params[:challenge][:sketchfebs_attributes][index][:sketchfeb] = params[:challenge][:sketchfebs_attributes][index][:sketchfeb_cache]
						  end
					end
				super	
			
			elsif (params[:challenge].present? && params[:challenge][:marmosets_attributes].present?)
					params[:challenge][:marmosets_attributes].each do |index,img|
						  unless params[:challenge][:marmosets_attributes][index][:marmoset].present?
							params[:challenge][:marmosets_attributes][index][:marmoset] = params[:challenge][:marmosets_attributes][index][:marmoset_cache]
						  end
					end
				super	
			
			elsif (params[:challenge].present? && params[:challenge][:tags_attributes].present?)
					params[:challenge][:tags_attributes].each do |index,img|
						  unless params[:challenge][:tags_attributes][index][:tag].present?
							params[:challenge][:tags_attributes][index][:tag] = params[:challenge][:tags_attributes][index][:tag]
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
	   column 'Closing Date' do |cd|
			cd.closing_date
	   end
	

	   column 'Status' do |user|
		  user.status? ? 'Active' : 'Inactive'
		end
		actions
  end
    
  
   show do
		attributes_table do
		  row :title
		  row 'Description' do |cat|
			cat.description.html_safe
		  end
		  row :challenge_type_id do |cat|
			(cat.challenge_type_id == 0) ? 'Gallery Contest'  : (cat.challenge_type_id == 1) ? 'Tutorial Contest'  :'Download Contest'
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
				if challenge.images.present?
				  challenge.images.each do |img|
					span do
					  image_tag(img.try(:image).try(:thumb).try(:url), class: "show-img")
					end
				  end
				end
			end
		  end
		  row 'Videos' do
			ul class: "image-blk" do
				if challenge.videos.present?
					challenge.videos.each do |img|
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
				if challenge.upload_videos.present?
				  challenge.upload_videos.each do |img|
					span do
						raw('<iframe title="Video" width="300" height="200" src="'+img.uploadvideo.url+'" frameborder="0" allowfullscreen></iframe>')
					
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
		column 'Username' do |uname|
			(uname.user_id == 1 && uname.is_admin == 'Y') ? 'Admin' : User.find_by(id: uname.user_id).try(:firstname)
		end
		column :challenge_type_id do |cat|
			(cat.challenge_type_id == 0) ? 'Gallery Contest'  : (cat.challenge_type_id == 1) ? 'Tutorial Contest'  :'Download Contest'
	    end 
		column :closing_date
	
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
		Challenge.where(id: ids).update_all(status: inputs[:status])
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
