ActiveAdmin.register Chapter do
  menu label: 'Chapter', parent: 'Tutorial',priority: 5
  config.sort_order = 'created_at_asc'

  permit_params :title, :image, :tutorial_id, :media_contents_attributes => [:id,:mediacontent,:media_caption,:mediacontentable_id,:mediacontentable_type, :_destroy, :tmp_mediacontent, :mediacontent_cache, :video_duration, :media_description, :media_type]


  controller do
    def action_methods
      super
      if current_admin_user.role == 'super_admin'
        super
      else
        disallowed = []
        disallowed << 'index' if (!current_admin_user.has_permission('chapter_read') && !current_admin_user.has_permission('chapter_write') && !current_admin_user.has_permission('chapter_delete'))
        disallowed << 'delete' unless (current_admin_user.has_permission('chapter_delete'))
        disallowed << 'create' unless (current_admin_user.has_permission('chapter_write'))
        disallowed << 'new' unless (current_admin_user.has_permission('chapter_write'))
        disallowed << 'edit' unless (current_admin_user.has_permission('chapter_write'))
        disallowed << 'destroy' unless (current_admin_user.has_permission('chapter_delete'))
        super - disallowed
      end
    end
  end


  	controller do
  		def create
				if (params[:chapter].present? && params[:chapter][:media_contents_attributes].present?)
					params[:chapter][:media_contents_attributes].each do |index,img|
						 
							params[:chapter][:media_contents_attributes][index][:media_type] = params[:chapter][:media_contents_attributes][index][:media_type]
							params[:chapter][:media_contents_attributes][index][:mediacontent] = params[:chapter][:media_contents_attributes][index][:mediacontent]
							params[:chapter][:media_contents_attributes][index][:media_caption] = params[:chapter][:media_contents_attributes][index][:media_caption]
							params[:chapter][:media_contents_attributes][index][:video_duration] = params[:chapter][:media_contents_attributes][index][:video_duration]
							params[:chapter][:media_contents_attributes][index][:media_description] = params[:chapter][:media_contents_attributes][index][:media_description]
					
					end
					super 
				end
		end 

		def update
			if (params[:chapter].present? && params[:chapter][:media_contents_attributes].present?)
				#abort(params.inspect)
					params[:chapter][:media_contents_attributes].each do |index,img|
						 
							params[:chapter][:media_contents_attributes][index][:media_type] = params[:chapter][:media_contents_attributes][index][:media_type]
							params[:chapter][:media_contents_attributes][index][:mediacontent] = params[:chapter][:media_contents_attributes][index][:mediacontent]
							params[:chapter][:media_contents_attributes][index][:media_caption] = params[:chapter][:media_contents_attributes][index][:media_caption]
							params[:chapter][:media_contents_attributes][index][:video_duration] = params[:chapter][:media_contents_attributes][index][:video_duration]
							params[:chapter][:media_contents_attributes][index][:media_description] = params[:chapter][:media_contents_attributes][index][:media_description]
					
					end
				super 
			end
		end

  	end	





  # Index Page
	index :download_links => ['csv'] do
    selectable_column
    column 'Image' do |img|
      image_tag img.try(:image).try(:url, :thumb), height: 50, width: 50
     end
    column "Tutorial" do |sys_email|
    	Tutorial.find_by(id: sys_email.tutorial_id).try(:title)
      
    end
    column "Title" do |sys_email|
      sys_email.title
    end
    column :created_at
    actions
  end

  csv do
  	 column "Tutorial" do |sys_email|
    	Tutorial.find_by(id: sys_email.tutorial_id).try(:title)
      
     end
    column :title
 	column :created_at
  end

  # New/Edit Form
  form do |f|
    f.inputs "Tutorial Chapter" do
    	
		f.input :tutorial_id, as: :select, collection: Tutorial.all.pluck(:title, :id), :input_html => { :class => "chosen-input" }, include_blank: false,multiple: false ,label: 'Select Tutorial'
      f.input :title
    	f.input :image
    end

    f.inputs 'Media' do
			f.has_many :media_contents, allow_destroy: true, new_record: true do |ff|
			  #ff.input :media_type, as: :radio, collection: MediaContent::MEDIA_CONTENT_TYPE, :input_html => { :class => "chosen-input1 mediatype_value" }
			  ff.input :media_type, as: :select, collection: MediaContent::MEDIA_CONTENT_TYPE, :input_html => { :class => "chosen-input  mediatype_value" }, include_blank: false,multiple: false ,label: 'Select Media Type'
			  ff.input :mediacontent, label: "Media",  :input_html => { :class => "mediacontent" } #, hint: ff.template.video_tag(ff.object.uploadvideo.try(:url), :size => "150x150")
			  ff.input :mediacontent_cache, :as => :hidden
			  #ff.input :media_caption
			  ff.input :video_duration,  :input_html => { :class => "video_duration" } 
			  ff.input :media_description,  :input_html => { :class => "media_description" } , label: 'Content'
			end
	end
    f.actions
  end

  # Filters
  filter :tutorial_id, as: :select, collection: Tutorial.all.pluck(:title, :id), label: 'Select Tutorial'
  filter :created_at

  # Show Page
  show :title => proc{|sys_email| truncate(sys_email.title, length: 50) } do
    attributes_table do
     row 'Image' do |img|
      image_tag img.try(:image).try(:url, :thumb), height: 50, width: 50
     end
      row "Tutorial" do |sys_email|
    	Tutorial.find_by(id: sys_email.tutorial_id).try(:title)
      
      end
	  row :title    
      row :created_at
    end
  end


end
