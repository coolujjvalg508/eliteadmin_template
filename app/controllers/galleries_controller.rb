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

    def show
         @gallery = Gallery.find_by(paramlink: params[:paramlink])
        #abort(@gallery.upload_videos.to_json)
       # abort(@gallery.software_expertise.to_json)
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
            redirect_to index_gallery_path, notice: 'Project Successfully Created.'

        else
            render 'new'
        end    

      #abort(@gallery.errors.to_json)
    

    end 
  
    def edit

        @gallery = Gallery.find_by(paramlink: params[:paramlink])
        #abort(@gallery.tags.to_json)
        render 'new'
    end 
  
    def update

        title = params['gallery']['title']

        slugVal = create_slug(title)

        final_slug = check_slug_available(slugVal, slugVal, 0, gallery_id = params[:id])

        #abort(params['gallery']['tag']['tag'].to_json)

        params['gallery']['paramlink'] = final_slug


        if params['commit'] == 'Publish'
            params['gallery']['is_save_to_draft'] = 0

        elsif params['commit'] == 'SaveDraft'
            params['gallery']['is_save_to_draft'] = 1
        end

     #  caption_image  = params[:gallery][:avatar_caption]
     #  abort(caption_image[2].present?)
      #abort(params.inspect)


       # abort(params['gallery']['images_attributes_default'].to_json)

        @gallery = Gallery.find_by(id: params[:id])
        if @gallery.update(gallery_params)

            ############ Images update start #################
            #to delete images 
            if params['gallery']['removedimages'].present?
              removedimages_array = params[:gallery][:removedimages].split(',')
              if removedimages_array.present?
                Image.where("id IN (?)", removedimages_array).delete_all
              end
            end

            #to update caption of existing images
            if params['gallery']['images_attributes_default'].present?
              params['gallery']['images_attributes_default'].each do |data_update|
                Image.where('id = ?', data_update[0]).update_all(:caption_image => data_update[1]['caption_image'])  
              end
            end

            ############ Images update end #################

            ############ Video url update start #################

            #to delete video url 
            if params['gallery']['removedvideourl'].present?
              removedvideourl_array = params[:gallery][:removedvideourl].split(',')
              if removedvideourl_array.present?
                Video.where("id IN (?)", removedvideourl_array).delete_all
              end
            end

            #to update caption of existing video url
            if params['gallery']['videos_attributes_default'].present?
              params['gallery']['videos_attributes_default'].each do |data_update|
                Video.where('id = ?', data_update[0]).update_all(:caption_video => data_update[1]['caption_video'])  
              end
            end

            ############ Video url update end #################

            ############ sketchfab update start #################

            #to delete Sketchfeb
            if params['gallery']['removedsketchfab'].present?
              removedsketchfab_array = params[:gallery][:removedsketchfab].split(',')
              if removedsketchfab_array.present?
                Sketchfeb.where("id IN (?)", removedsketchfab_array).delete_all
              end
            end

            #to update caption of existing sketchfebs url
            if params['gallery']['sketchfebs_attributes_default'].present?
              params['gallery']['sketchfebs_attributes_default'].each do |data_update|
                Sketchfeb.where('id = ?', data_update[0]).update_all(:caption_sketchfeb => data_update[1]['caption_sketchfeb'])  
              end
            end

            ############ sketchfab update end #################

            ############ upload video update start #################

            #to delete upload video 
            if params['gallery']['removedUploadVideo'].present?
              removed_upload_video_array = params[:gallery][:removedUploadVideo].split(',')
              if removed_upload_video_array.present?
                UploadVideo.where("id IN (?)", removed_upload_video_array).delete_all
              end
            end

            #to update caption of existing upload video
            if params['gallery']['upload_videos_attributes_default'].present?
              params['gallery']['upload_videos_attributes_default'].each do |data_update|
                UploadVideo.where('id = ?', data_update[0]).update_all(:caption_upload_video => data_update[1]['caption_upload_video'])  
              end
            end

            ############ upload video update end #################

            ############ marmoset update start #################

            #to delete upload video 
            if params['gallery']['removedMarmoset'].present?
              removed_marmoset_array = params[:gallery][:removedMarmoset].split(',')
              if removed_marmoset_array.present?
                MarmoSet.where("id IN (?)", removed_marmoset_array).delete_all
              end
            end

            #to update caption of existing upload video
            if params['gallery']['marmo_sets_attributes_default'].present?
              params['gallery']['marmo_sets_attributes_default'].each do |data_update|
                MarmoSet.where('id = ?', data_update[0]).update_all(:caption_marmoset => data_update[1]['caption_marmoset'])
              end
            end

            ############ marmoset update end #################




            #to delete all previous tags
            Tag.where("tagable_id = ? AND tagable_type = 'Gallery'", @gallery['id']).delete_all

            #to add new tags
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
            redirect_to index_gallery_path, notice: 'Project Successfully Updated.'

        else
            render 'new'
        end    

      #abort(@gallery.errors.to_json)
    

    end 

    def upload_drag_image
         #  abort(params.to_json)
    end

    def trash
          Gallery.where('id = ?',params[:id]).update_all(:is_trash => 1)  
          flash[:notice] = 'Post has been successfully deleted.'
          redirect_to index_gallery_path

    end    

    def get_upload_video_thumbnail

      dir_path = File.dirname(params[:url])
      thumbnail = "#{dir_path}/thumbnail.jpg"
      data = {'thumbnail' => thumbnail}
      render :json => data.to_json, status: 200

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