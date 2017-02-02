class GalleriesController < ApplicationController

    before_action :authenticate_user!, only: [:new, :crete, :edit, :update]
 
    def index

    end 
  
    def new
        #VideoInfo.disable_providers = %w[Wistia Vkontakte] 
        #video = VideoInfo.new('https://www.youtube.com/watch?v=lvtfD_rJ2hE')
       # video = VideoInfo.new('http://fast.wistia.com/embed/medias/pxonqr42is')

        #abort(video.to_json)
        
        @gallery = current_user.gallery.new
        

    end 

    def getsubjectmatter
            post_type_id =  params[:post_type_id]
            category     = SubjectMatter.where(parent_id: post_type_id.to_i).order('name asc').pluck(:name, :id)
            render json: category, status: 200
    end


    def get_video_detail_from_url
        url     =   params[:url]

        VideoInfo.disable_providers = %w[Wistia Vkontakte] 

        video = VideoInfo.new(url)

        if video.present?

            data = {'title' => video.title, 'thumbnail' => video.thumbnail_medium}

            render :json => data.to_json, status: 200

        else
            render :json => video, status: 300            
        end
        #abort(video.thumbnail_medium.to_json)

    end    


   
    def create


        title = params['gallery']['title']

        slugVal = create_slug(title)

        final_slug = check_slug_available(slugVal, slugVal, 0, gallery_id = 0)

        #abort(params['gallery']['tag']['tag'].to_json)

        params['gallery']['paramlink'] = final_slug


        if params['commit'] == 'Publish'
            params['gallery']['is_save_to_draft'] = 0

        elsif params['commit'] == 'SaveDraft'
            params['gallery']['is_save_to_draft'] = 1
          
        end 

     #  caption_image  = params[:gallery][:avatar_caption]
     #  abort(caption_image[2].present?)
     # abort(params.inspect)


        @gallery = Gallery.new(gallery_params)

        if @gallery.save

            
           
            tags_list = params['gallery']['tag']['tag']

            tags_list.reject!{|a| a==""}

            tags_list.each do |tag_val|

                Tag.create(
                    tag: tag_val, 
                    tagable_id: @gallery['id'], 
                    tagable_type: 'Gallery'
                )

            end

             #abort(@gallery.to_json)   

            ############################################
         
            if params[:gallery][:crop_x].present?
                @gallery.company_logo = @gallery.company_logo.resize_and_crop
                @gallery.save!
                @gallery.company_logo.recreate_versions!
            end
            ############################################

            if params[:gallery][:avatar].present?
                 caption_image  = params[:gallery][:avatar_caption]
                  my_array = params[:gallery][:removedids].split(',')
                 #abort(my_array.inspect)
                 params[:gallery][:avatar].each.with_index do |a,index|
                   caption = ''  
                   if caption_image[index].present?
                        caption = caption_image[index]['caption_image']
                   end        


                    if !my_array.include?(index.to_s)  
                         @image = @gallery.images.create!(:image => a[:image],:caption_image => caption)
                    end
                   
                 end
            end  
            ############################################
            redirect_to new_gallery_path, notice: 'Project Successfully Created'

        else
            render 'new'
        end    

      #abort(@gallery.errors.to_json)
    

    end 
  
    def edit

    end 
  
    def update

    end

    def upload_drag_image
           abort(params.to_json)
    end


    private
        def gallery_params
            params.require(:gallery).permit(:user_id, :title, :description, :post_type_category_id, :medium_category_id, {:subject_matter_id => []}, {:team_member => []}, {:challenge => []}, :has_adult_content, {:software_used => []}, :paramlink, :is_admin, :use_tag_from_previous_upload, :is_featured, :show_on_cgmeetup, :show_on_website, :schedule_time , :zoom_w, :zoom_h, :zoom_x, :zoom_y, :drag_x, :drag_y, :rotation_angle, :crop_x, :crop_y, :crop_w, :crop_h, :company_logo, :publish, :visibility, :is_save_to_draft, :tags_attributes => [:id, :tag, :tagable_id, :tagable_type, :_destroy, :tmp_tag, :tag_cache], :images_attributes => [:id,:image,:caption_image,:imageable_id,:imageable_type, :_destroy,:tmp_image,:image_cache], :videos_attributes => [:id,:video,:caption_video,:videoable_id,:videoable_type, :_destroy,:tmp_image,:video_cache], :sketchfebs_attributes => [:id,:sketchfeb,:sketchfebable_id,:sketchfebable_type, :_destroy,:tmp_sketchfeb,:sketchfeb_cache,:caption_sketchfeb], :marmo_sets_attributes => [:id,:marmoset,:marmosetable_id,:marmosetable_type, :_destroy,:tmp_image,:marmoset_cache,:caption_marmoset], :upload_videos_attributes => [:id,:uploadvideo,:caption_upload_video,:uploadvideoable_id,:uploadvideoable_type, :_destroy,:tmp_image,:uploadvideo_cache])
        end

        def check_slug_available(slugVal, newSlugVal, i, gallery_id)

            result = Gallery.where('id != ? AND paramlink = ?', gallery_id, newSlugVal).count

            if result == 0
                return newSlugVal
            else
                i = i + 1
                newSlugVal = slugVal + '-' + i.to_s
                check_slug_available(slugVal, newSlugVal, i, gallery_id)
            end  

        end 

    
  
end
