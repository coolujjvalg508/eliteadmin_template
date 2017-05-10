class GalleriesController < ApplicationController

    before_action :authenticate_user!, only: [:new, :crete, :edit, :update, :get_gallery_post_list, :count_user_gallery_post]
 
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
        @gallery        = Gallery.find_by(paramlink: params[:paramlink])
        
        @collection     = Collection.new
        @report         = Report.new
        @latest_post    = Gallery.where("paramlink != ?",params[:paramlink]).order('id desc').limit(8)
     
        #abort(@gallery.post_type_category_id.to_json)
        @blocked_users    = BlockUser.where("user_id="+@gallery.user_id.to_s+" AND block_user_id::jsonb ?| array['" + current_user.id.to_s + "']")

        if @gallery.post_type_category_id == 1
            render 'artshow'

          elsif  @gallery.post_type_category_id == 2
            render 'videoshow'
         
          else 
            render 'show'
        end 
    end  

    def create_collection
       # abort(params.to_json)        
          gallery_id              = params[:collection][:gallery_id] 
          title                   = params[:collection][:title].strip 
          is_collection_exist     = Collection.where(title: title)

          if title==''
             result = {'res' => 0, 'message' => 'Collection name cannot be blank.'}

          elsif is_collection_exist.present?
              result = {'res' => 0, 'message' => 'Collection name already exist.'}
             # render json: {'res' => 0, 'message' => 'Title already exist.'}, status: 200
          else
              Collection.create(gallery_id: gallery_id, title: title)
              result = {'res' => 1, 'message' => 'Post has successfully added to collection.'}
              #flash[:notice] = 'Post has successfully added to collection.'
             # redirect_to request.referer

          end 
        render json: result, status: 200
      #redirect_to request.referer
         
    end  

    def save_like
          gallery_id     = params[:gallery_id]
          artist_id      = params[:artist_id]
          user_id        = current_user.id
          is_like_exist  = PostLike.where(user_id: user_id, post_id: gallery_id, post_type: 'Gallery').first
          result         = ''
          galleryrecord  = Gallery.where(id: gallery_id).first

          activity_type = ''
          if is_like_exist.present?
                activity_type = 'disliked'
                PostLike.where(user_id: user_id, post_id: gallery_id, post_type: 'Gallery').delete_all 
                Notification.where(user_id: user_id,  artist_id: artist_id,  post_id: gallery_id, notification_type: "like", section_type: 'Gallery').delete_all
                newlike_count  =  (galleryrecord.like_count == 0) ? 0 : galleryrecord.like_count - 1
                galleryrecord.update(like_count: newlike_count) 

                result  = {'res' => 0, 'message' => 'Post has disliked'}

          else
                activity_type = 'liked'
                PostLike.create(user_id: user_id, artist_id: artist_id, post_id: gallery_id, post_type: 'Gallery')  
                
                newlike_count  =  galleryrecord.like_count + 1
                galleryrecord.update(like_count: newlike_count) 

                result  = {'res' => 1, 'message' => 'Post has liked'}
                Notification.create(user_id: user_id,  artist_id: artist_id,  post_id: gallery_id, notification_type: "like", is_read: 0, section_type: 'Gallery')

          end 

          LatestActivity.create(user_id: user_id,  artist_id: artist_id,  post_id: gallery_id, activity_type: activity_type, section_type: 'Gallery')  
            

          render json: result, status: 200       
    end  

     def check_save_like
          gallery_id     = params[:gallery_id]
          user_id        = current_user.id
          is_like_exist  = PostLike.where(user_id: user_id, post_id: gallery_id, post_type: 'Gallery').first
          result = ''
          if is_like_exist.present?
                result  = {'res' => 1, 'message' => 'Post has already liked'}
          else
                result  = {'res' => 0, 'message' => 'Post has not liked'}
          end 
         
          render json: result, status: 200       
    end  


    def follow_artist
        
          artist_id        = params[:artist_id]
          user_id          = current_user.id
          is_follow_exist  = Follow.where(user_id: user_id, artist_id: artist_id, post_type: '').first
          result = ''
          
          userrecord       = User.where(id: artist_id).first

          if is_follow_exist.present?
                Follow.where(user_id: user_id, artist_id: artist_id, post_type: '').delete_all 
                Notification.where(user_id: user_id,  artist_id: artist_id, notification_type: "follow user", section_type: 'Gallery').delete_all  
                newfollow_count  =  (userrecord.follow_count == 0) ? 0 : userrecord.follow_count - 1
                userrecord.update(follow_count: newfollow_count) 

                result  = {'res' => 0, 'message' => 'Artist Not Follow'}
          else
                Follow.create(user_id: user_id, artist_id: artist_id, post_type: '')
                Notification.create(user_id: user_id,  artist_id: artist_id,  post_id: "", notification_type: "follow user", is_read: 0, section_type: 'Gallery')  

                newfollow_count  =  userrecord.follow_count + 1
                userrecord.update(follow_count: newfollow_count) 

                result  = {'res' => 1, 'message' => 'Artist Follow'}

          end 


          render json: result, status: 200    
             
    end  

     def check_follow_artist
          artist_id     = params[:artist_id]
          user_id        = current_user.id
          is_like_exist  = Follow.where(user_id: user_id, artist_id: artist_id, post_type: '').first
          result = ''
          if is_like_exist.present?
                result  = {'res' => 1, 'message' => 'Artist already followed'}
          else
                result  = {'res' => 0, 'message' => 'Artist not followed'}
          end 

          render json: result, status: 200       
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

           LatestActivity.create(user_id: current_user.id, artist_id: current_user.id, post_id: @gallery['id'], activity_type: 'created', section_type: 'Gallery')  
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
            LatestActivity.create(user_id: current_user.id, artist_id: current_user.id, post_id: @gallery['id'], activity_type: 'updated', section_type: 'Gallery')  
            ############################################
            redirect_to index_gallery_path, notice: 'Project Successfully Updated.'

        else
            render 'new'
        end    

      #abort(@gallery.errors.to_json)
    

    end 

    def save_comment
          post_id           = params[:gallery_id]
          description       = params[:description]
          section_type      = params[:section_type]

          PostComment.create(title: "", description: description, user_id: current_user.id, post_id: post_id, section_type: section_type) 
         

          galleryrecord               = Gallery.where(id: post_id).first
          newcomment_count_count      = galleryrecord.comment_count + 1
          galleryrecord.update(comment_count: newcomment_count_count) 
          
          Notification.create(user_id: current_user.id, post_id: post_id, artist_id: galleryrecord.user_id, section_type: section_type, notification_type: "comment") 

          render :json => {'res' => 1, 'message' => 'Comment has successfully sent'}, status: 200
    end  



    def get_comment

          gallery_id           = params[:gallery_id]
          user_id              = params[:user_id]
          section_type         = params[:section_type]

          commentrecord        = PostComment.where("post_id = ? AND user_id = ? AND section_type=?",gallery_id,user_id,section_type).order('id DESC')
          

          str = ''
          if commentrecord.present?
             
            commentrecord.each_with_index do |value, index|
    
              str += '<div class="customer-wrap clearfix"><div class="customerleft"><img src = ' + value.user.image.user_activity.url + ' alt= "user"></div><div class="customerright"><div class="day-txt"><span>' + value.user.firstname + '</span> '+ DateTime.parse(value.created_at.to_s).strftime("%Y-%m-%d %H:%M:%S").to_s + '</div> <div class="date-txt">' + value.description + ' </div></div></div>'
##
              end  


         end  
       
        render :json => {'res' => 1, 'data' => str, 'message' => 'data get successfully'}, status: 200   




    end      


    def get_like_comment_view_gallery
          
          post_id           = params[:gallery_id]
          gallery_record    = Gallery.where("id= ?",post_id).first
          #gallerylike       = PostLike.where('post_id = ?', post_id).count
          #gallerycomment    = PostComment.where('post_id = ?', post_id).count
          res               = {'gallerylike': gallery_record.like_count,'gallerycomment': gallery_record.comment_count,'galleryview': gallery_record.view_count} 
          render :json => res, status: 200

      
    end  

    def upload_drag_image
         #  abort(params.to_json)
    end

    

    def make_trash
         #abort(params.to_json)
         paramlink             =  params[:paramlink]
         @is_gallery_exist     =  Gallery.where(paramlink: paramlink).first
        # abort(@is_gallery_exist.to_json)
         if @is_gallery_exist.present?
            Gallery.where('id = ?',@is_gallery_exist.id).update_all(:is_trash => 1)  
            flash[:notice] = 'Post has successfully trashed.'
            redirect_to index_gallery_path
         end
          
    end   

    def delete_from_trash
          #abort(params.to_json)
         paramlink             =  params[:paramlink]
         @is_gallery_exist     =  Gallery.where(paramlink: paramlink).first
        # abort(@is_gallery_exist.to_json)
         if @is_gallery_exist.present?
            Gallery.where('id = ?',@is_gallery_exist.id).delete_all
            flash[:notice] = 'Post has successfully deleted.'
            redirect_to index_gallery_path
         end

    end  


    def restore_post
       
       #abort(params.to_json)
         paramlink             =  params[:paramlink]
         @is_gallery_exist     =  Gallery.where(paramlink: paramlink).first
        # abort(@is_gallery_exist.to_json)
         if @is_gallery_exist.present?
            Gallery.where('id = ?',@is_gallery_exist.id).update_all(:is_trash => 0)  
            flash[:notice] = 'Post has successfully restored.'
            redirect_to index_gallery_path
         end

  end  

    def get_upload_video_thumbnail

      dir_path = File.dirname(params[:url])
      thumbnail = "#{dir_path}/thumbnail.jpg"
      data = {'thumbnail' => thumbnail}
      render :json => data.to_json, status: 200

    end


    def get_gallery_post_list
    #abort(params.to_json)
        conditions = "user_id=#{current_user.id} AND is_admin != 'Y'"

        if(params[:post_type_category_id] && params[:post_type_category_id] != '')
          conditions += ' AND post_type_category_id=' + params[:post_type_category_id]
        end 

        if(params[:medium_category_id] && params[:medium_category_id] != '')
          conditions += ' AND medium_category_id=' + params[:medium_category_id]
        end 

        if(params[:view]) 
          if (params[:view] == 'featured')
            conditions += ' AND is_featured=TRUE AND is_trash=0'
          elsif (params[:view] == 'published')
            conditions += ' AND publish=1 AND is_trash=0'
          elsif (params[:view] == 'drafts')
            conditions += ' AND is_save_to_draft=1 AND is_trash=0'
          elsif (params[:view] == 'trash')
            conditions += ' AND is_trash=1'
          end
        end

        #result = Gallery.where(conditions).order('id DESC').page(params[:page]).per(10)
        result = Gallery.where(conditions).order('id DESC')

        #result = result + result + result + result + result + result + result + result + result + result + result + result

        #abort(result.total_count.to_json)
        #abort(result.total_pages.to_json)


        #abort(data.to_json)
        #render json: result, status: 200  
        render :json => result.to_json(:include => [:category, :medium_category]), status: 200

  end

  def count_user_gallery_post

        conditions = "user_id=#{current_user.id} AND is_admin != 'Y' "

        r_data = Gallery.where(conditions)

        total_count = r_data.count
        total_trash = total_featured = total_published = total_draft = 0

        r_data.each do |val|

          if val['is_featured'] == TRUE
            if val['is_trash'] == 0
              total_featured = total_featured + 1
            end
          end  

          if val['publish'] == 1
            if val['is_trash'] == 0
              total_published = total_published + 1
            end
          end  

          if val['is_save_to_draft'] == 1
            if val['is_trash'] == 0
              total_draft = total_draft + 1
            end
          end 

          if val['is_trash'] == 1
            total_trash = total_trash + 1
          end   

        end  

        result = {'total_count' => total_count, 'total_featured' => total_featured, 'total_published' => total_published, 'total_draft' => total_draft, 'total_trash'=> total_trash}

        render json: result, status: 200  

        #abort(result.to_json)
  end  

    #  ******************************************* Browse All Task ******************************************************************* #

    def browse_all_artwork
        @medium_type = SubjectMatter.order('name ASC')
    end

    def browse_all_awards
    end
    
    def browse_all_challenge
    end
    
    def browse_all_gallery
        @medium_type = SubjectMatter.where("parent_id = 1").order('name ASC')
    end
    
    def browse_all_video
      @medium_type = SubjectMatter.where("parent_id = 2").order('name ASC')
    end
    
    def browse_all_work_in_progress
    end
    
   
    def get_gallery_list

        conditions = "is_trash=0"
         
        if(params[:post_type_category_id] != '0')
            if(params[:post_type_category_id] && params[:post_type_category_id] != '')
              conditions += ' AND post_type_category_id=' + params[:post_type_category_id]
            else 
              conditions += ' AND post_type_category_id= 1'
            end 
        end    
 
        if(params[:medium_category_id] && params[:medium_category_id] != '')
          conditions +=  " AND subject_matter_id::jsonb ?| array['" + params[:medium_category_id] + "'] "
          #conditions += ' AND subject_matter_id=' + params[:medium_category_id]
        end 


        #if(params[:is_feature] && params[:is_feature] != '')
       #   conditions += ' AND is_featured=' + params[:is_feature] 
       # end 

          orderby = 'id DESC'

        if(params[:is_feature] && params[:is_feature] != '')

              if params[:is_feature] == 'RECENT'
                   
                   orderby = 'id DESC'
      
              elsif params[:is_feature] == 'POPULAR'
                   
                   orderby = 'view_count DESC, id DESC'

             elsif params[:is_feature] == 'AWARDED'


              elsif params[:is_feature] == 'TOPLIKED'  

                  orderby = 'like_count DESC, id DESC'

              elsif params[:is_feature] == 'TOPVIEWED'    

                  orderby = 'view_count DESC, id DESC'

              elsif params[:is_feature] == 'TOPCOMMENTED'  
                  
                   orderby = 'comment_count DESC, id DESC'

             end
                    
        end


       # abort(orderby.to_json)
        #result = Gallery.where(conditions).order('id DESC').page(params[:page]).per(10)
        
        if (params[:browse_by] && (params[:browse_by] == 'popular' || params[:browse_by] == 'top'))
            
              if params[:browse_by] == 'popular'
                  
                  result    = Gallery.where(conditions).order('view_count DESC, id DESC')
              
              elsif params[:browse_by] == 'top'

                  result    = Gallery.where(conditions).order('like_count DESC, id DESC')
              
              end             
            
        else  
           result    = Gallery.where(conditions).order(orderby)
        end

        final_data = []
        if result.present?
          
         result.each_with_index do |value, index|
                 video_data    = []
                  if value.videos.present?  
                        value.videos.each_with_index do |video_value, video_index|

                               if(video_value.video.include?('youtube')) 
                                    if video_value.video[/youtu\.be\/([^\?]*)/]
                                      youtube_id = $1
                                    else
                                      video_value.video[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
                                      youtube_id = $5
                                    end
                                  
                                  video_data[video_index] =   { 'type': 'Youtube', 'videoid': 'https://www.youtube.com/embed/'+ youtube_id }
                                
                               elsif(video_value.video.include?('vimeo')) 
                                    match = video_value.video.match(/https?:\/\/(?:[\w]+\.)*vimeo\.com(?:[\/\w]*\/?)?\/(?<id>[0-9]+)[^\s]*/)

                                    if match.present?
                                      vimeoid = match[:id]
                                      video_data[video_index] =   { 'type': 'Vimeo', 'videoid': 'https://player.vimeo.com/video/'+vimeoid }   
                                   
                                    end
                                
                                elsif(video_value.video.include?('dailymotion'))  
                                    match =  video_value.video.gsub('http://www.dailymotion.com/video/', "")
                                    match1  = match.index('_')
                                    match = match[0...match1]
                                    if match.present?
                                      dailymotionid = match
                                      video_data[video_index] =   { 'type': 'Dailymotion', 'videoid': '//www.dailymotion.com/embed/video/'+dailymotionid }   
                                                          
                                    end 
                                end
                        end  
                  end   
               
                  final_data[index]  = {'result': value, 'user': value.user, 'category': value.category, 'medium_category': value.medium_category, 'image': value.images,'video': value.videos,'upload_video': value.upload_videos,'sketchfeb': value.sketchfebs,'marmoset': value.marmo_sets,'video_data': video_data}

             end           
        
        end            

          
       render :json => final_data.to_json, status: 200

    end 


    def get_portfolio_list
#abort(params.to_json)
        
       artist_id  = ''
       
       if params[:artist_id].present?
             artist_id  = params[:artist_id]
       else
             artist_id  = current_user.id

       end 

      # abort(artist_id.to_json)

        conditions = "is_trash=0 AND user_id =" + artist_id.to_s + " AND is_admin = 'N'"
         
        if(params[:post_type_category_id] != '0')
            if(params[:post_type_category_id] && params[:post_type_category_id] != '')
              conditions += ' AND post_type_category_id=' + params[:post_type_category_id]
            end 
        end    
 
        if(params[:medium_category_id] && params[:medium_category_id] != '')
          conditions +=  " AND subject_matter_id::jsonb ?| array['" + params[:medium_category_id] + "'] "
          #conditions += ' AND subject_matter_id=' + params[:medium_category_id]
        end 

  
       # abort(conditions.to_json)

        #if(params[:is_feature] && params[:is_feature] != '')
       #   conditions += ' AND is_featured=' + params[:is_feature] 
       # end 

          orderby = 'id DESC'

        if(params[:is_feature] && params[:is_feature] != '')

              if params[:is_feature] == 'RECENT'
                   
                   orderby = 'id DESC'
      
              elsif params[:is_feature] == 'POPULAR'
                   
                   orderby = 'view_count DESC, id DESC'

             elsif params[:is_feature] == 'AWARDED'


              elsif params[:is_feature] == 'TOPLIKED'  

                  orderby = 'like_count DESC, id DESC'

              elsif params[:is_feature] == 'TOPVIEWED'    

                  orderby = 'view_count DESC, id DESC'

              elsif params[:is_feature] == 'TOPCOMMENTED'  
                  
                   orderby = 'comment_count DESC, id DESC'

             end
                    
        end


       # abort(orderby.to_json)
        #result = Gallery.where(conditions).order('id DESC').page(params[:page]).per(10)
        
        if (params[:browse_by] && (params[:browse_by] == 'popular' || params[:browse_by] == 'top'))
            
              if params[:browse_by] == 'popular'
                  
                  result    = Gallery.where(conditions).order('view_count DESC, id DESC')
              
              elsif params[:browse_by] == 'top'

                  result    = Gallery.where(conditions).order('like_count DESC, id DESC')
              
              end             
            
        else  
           result    = Gallery.where(conditions).order(orderby)
        end

        #abort(result.to_json)

        final_data = []
        if result.present?
          
         result.each_with_index do |value, index|
                 video_data    = []
                  if value.videos.present?  
                        value.videos.each_with_index do |video_value, video_index|

                               if(video_value.video.include?('youtube')) 
                                    if video_value.video[/youtu\.be\/([^\?]*)/]
                                      youtube_id = $1
                                    else
                                      video_value.video[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
                                      youtube_id = $5
                                    end
                                  
                                  video_data[video_index] =   { 'type': 'Youtube', 'videoid': 'https://www.youtube.com/embed/'+ youtube_id }
                                
                               elsif(video_value.video.include?('vimeo')) 
                                    match = video_value.video.match(/https?:\/\/(?:[\w]+\.)*vimeo\.com(?:[\/\w]*\/?)?\/(?<id>[0-9]+)[^\s]*/)

                                    if match.present?
                                      vimeoid = match[:id]
                                      video_data[video_index] =   { 'type': 'Vimeo', 'videoid': 'https://player.vimeo.com/video/'+vimeoid }   
                                   
                                    end
                                
                                elsif(video_value.video.include?('dailymotion'))  
                                    match =  video_value.video.gsub('http://www.dailymotion.com/video/', "")
                                    match1  = match.index('_')
                                    match = match[0...match1]
                                    if match.present?
                                      dailymotionid = match
                                      video_data[video_index] =   { 'type': 'Dailymotion', 'videoid': '//www.dailymotion.com/embed/video/'+dailymotionid }   
                                                          
                                    end 
                                end
                        end  
                  end   
               
                  final_data[index]  = {'result': value, 'user': value.user, 'category': value.category, 'medium_category': value.medium_category, 'image': value.images,'video': value.videos,'upload_video': value.upload_videos,'sketchfeb': value.sketchfebs,'marmoset': value.marmo_sets,'video_data': video_data}

             end           
        
        end            

          
       render :json => final_data.to_json, status: 200

    end 

    # **************************************************************************************************************# 


    def get_subject_matter_list
         post_type_category_id     = params[:post_type_category_id]
         subjectmatter             = SubjectMatter.where("parent_id = ?", post_type_category_id).order('name ASC')  

         render json: {'res' => 1, 'result' => subjectmatter}, status: 200

    end  


    def search

    end  

    def search_all_projects

       
       conditions = "is_trash=0"
         
        if(params[:title] && params[:title] != '')
          conditions += " AND title LIKE '%"+ params[:title] +"%'"
        end 

        order = 'DESC'
         if params[:order].present?
            order = 'ASC'
         end 

        result    = Gallery.where(conditions).order('id '+order)
       
        render :json => result.to_json(:include => [:user]), status: 200


    end  

    
    def save_view_count

       if params[:gallery_id].present?
            gallery_id      = params[:gallery_id]
            record          = Gallery.where("id = ?",gallery_id).first

            prevoius_view_count   = record.view_count
            newview_count         =  prevoius_view_count + 1
            
            record.update(view_count: newview_count) 
       end     
    end  


    def get_artist_gallery

        userid    = params[:user_id]
        result    = Gallery.where("user_id = ? AND is_admin = ?",userid,'N').order('id desc').limit(9)

         str = ''
          if result.present?
             
              result.each_with_index do |value, index|
                 str += '<li class="lists"><a href="/dashboard/projects/' + value.paramlink + '/show"><img src = ' + value.company_logo.event_small.url + ' alt= "img" class="img-responsive"></a></li>'
              end  
          end        
        
        render :json => {'res' => 1, 'data' => str, 'message' => 'data get successfully'}, status: 200   
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
