ActiveAdmin.register NewsContent do


	menu label: 'News Content' , parent: 'News'
    permit_params :title, :news_id, :media_contents_attributes => [:id,:mediacontent,:media_caption,:mediacontentable_id,:mediacontentable_type, :_destroy, :tmp_mediacontent, :mediacontent_cache, :video_duration, :media_description, :media_type]
	
	controller do
    def action_methods
      super
      if current_admin_user.role == 'super_admin'
        super
      else
        disallowed = []
        disallowed << 'index' if (!current_admin_user.has_permission('news_content_read') && !current_admin_user.has_permission('news_content_write') && !current_admin_user.has_permission('news_content_delete'))
        disallowed << 'delete' unless (current_admin_user.has_permission('news_content_delete'))
        disallowed << 'create' unless (current_admin_user.has_permission('news_content_write'))
        disallowed << 'new' unless (current_admin_user.has_permission('news_content_write'))
        disallowed << 'edit' unless (current_admin_user.has_permission('news_content_write'))
        disallowed << 'destroy' unless (current_admin_user.has_permission('news_content_delete'))
        super - disallowed
      end
    end
  end


  	controller do
  		def create
				if (params[:news_content].present? && params[:news_content][:media_contents_attributes].present?)
					params[:news_content][:media_contents_attributes].each do |index,img|
						 
							params[:news_content][:media_contents_attributes][index][:media_type] = params[:news_content][:media_contents_attributes][index][:media_type]
							params[:news_content][:media_contents_attributes][index][:mediacontent] = params[:news_content][:media_contents_attributes][index][:mediacontent]
							params[:news_content][:media_contents_attributes][index][:media_caption] = params[:news_content][:media_contents_attributes][index][:media_caption]
							#params[:chapter][:media_contents_attributes][index][:video_duration] = params[:chapter][:media_contents_attributes][index][:video_duration]
							params[:news_content][:media_contents_attributes][index][:media_description] = params[:news_content][:media_contents_attributes][index][:media_description]
					
					end
					super 
				end
		end 

		def update
			if (params[:news_content].present? && params[:news_content][:media_contents_attributes].present?)
				#abort(params.inspect)
					params[:news_content][:media_contents_attributes].each do |index,img|
						 
							params[:news_content][:media_contents_attributes][index][:media_type] = params[:news_content][:media_contents_attributes][index][:media_type]
							params[:news_content][:media_contents_attributes][index][:mediacontent] = params[:news_content][:media_contents_attributes][index][:mediacontent]
							params[:news_content][:media_contents_attributes][index][:media_caption] = params[:news_content][:media_contents_attributes][index][:media_caption]
							#params[:chapter][:media_contents_attributes][index][:video_duration] = params[:chapter][:media_contents_attributes][index][:video_duration]
							params[:news_content][:media_contents_attributes][index][:media_description] = params[:news_content][:media_contents_attributes][index][:media_description]
					
					end
				super 
			end
		end

  	end	





  # Index Page
	index :download_links => ['csv'] do
    selectable_column
   
    column "News" do |sys_email|
    	News.find_by(id: sys_email.news_id).try(:title)
      
    end
    column "Title" do |sys_email|
      sys_email.title
    end
    column :created_at
    actions
  end

  csv do
  	 column "News" do |sys_email|
    	News.find_by(id: sys_email.news_id).try(:title)
      
     end
    column :title
 	column :created_at
  end

  # New/Edit Form
  form do |f|
    f.inputs "News Chapter" do
    	
		f.input :news_id, as: :select, collection: News.all.pluck(:title, :id), :input_html => { :class => "chosen-input" }, include_blank: false,multiple: false ,label: 'Select News'
      f.input :title
    end

    f.inputs 'Media' do
			f.has_many :media_contents, allow_destroy: true, new_record: true do |ff|
			  #ff.input :media_type, as: :radio, collection: MediaContent::MEDIA_CONTENT_TYPE, :input_html => { :class => "chosen-input1 mediatype_value" }
			  ff.input :media_type, as: :select, collection: MediaContent::MEDIA_CONTENT_TYPE, :input_html => { :class => "chosen-input  mediatype_value" }, include_blank: false,multiple: false ,label: 'Select Media Type'
			  ff.input :mediacontent, label: "Media",  :input_html => { :class => "mediacontent" } #, hint: ff.template.video_tag(ff.object.uploadvideo.try(:url), :size => "150x150")
			  ff.input :mediacontent_cache, :as => :hidden
			  #ff.input :media_caption
			  #ff.input :video_duration,  :input_html => { :class => "video_duration" } 
			  ff.input :media_description,  :input_html => { :class => "media_description" } , label: 'Content'
			end
	end
    f.actions
  end

  # Filters
  filter :news_id, as: :select, collection: News.all.pluck(:title, :id), label: 'Select News'
  filter :created_at

  # Show Page
  show :title => proc{|sys_email| truncate(sys_email.title, length: 50) } do
    attributes_table do
      row "News" do |sys_email|
    	News.find_by(id: sys_email.news_id).try(:title)
      
      end
	  row :title    
      row :created_at
    end
  end


end
