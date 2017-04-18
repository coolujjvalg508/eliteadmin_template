class ContestsController < ApplicationController

	before_action :authenticate_user!, only: [:join_challenge,:index, :new, :create, :edit, :update, :get_contest_post_list]
	
	def index
	end

	
	def new
		@contest = Contest.new
	end	

	def create
		
		#abort(params.to_json)

        title = params['contest']['title']

        slugVal = create_slug(title)

        final_slug = check_slug_available(slugVal, slugVal, 0, gallery_id = 0)

        #abort(params['gallery']['tag']['tag'].to_json)

        params['contest']['paramlink'] = final_slug


       # if params['commit'] == 'Publish'
        #    params['contest']['is_save_to_draft'] = 0

       # elsif params['commit'] == 'SaveDraft'
        #    params['contest']['is_save_to_draft'] = 1
       # end 


        @contest = Contest.new(contest_params)

        if @contest.save
       
           tags_list = params['contest']['tag']['tag']
 
            tags_list.reject!{|a| a==""}

            tags_list.each do |tag_val|

                Tag.create(
                    tag: tag_val, 
                    tagable_id: @contest['id'], 
                    tagable_type: 'Contest'
                )

            end

             #abort(@contest.to_json)   

            ############################################
         
            if params[:contest][:crop_x].present?
                @contest.company_logo = @contest.company_logo.resize_and_crop
                @contest.save!
                @contest.company_logo.recreate_versions!
            end
            ############################################

            if params[:contest][:avatar].present?
                 caption_image  = params[:contest][:avatar_caption]
                  my_array = params[:contest][:removedids].split(',')
                 #abort(my_array.inspect)
                 params[:contest][:avatar].each.with_index do |a,index|
                   caption = ''  
                   if caption_image[index].present?
                        caption = caption_image[index]['caption_image']
                   end        


                    if !my_array.include?(index.to_s)  
                         @image = @contest.images.create!(:image => a[:image],:caption_image => caption)
                    end
                   
                 end
            end  

         #  LatestActivity.create(user_id: current_user.id, artist_id: current_user.id, post_id: @contest['id'], activity_type: 'created', section_type: 'Contest')  
            ############################################
            redirect_to contests_path, notice: 'Contests Successfully Created.'

        else
            render 'new'
        end    

     #abort(@contest.errors.to_json)
    end 

    def edit

        @contest = Contest.find_by(paramlink: params[:id])
        #abort(@contest.to_json)
        render 'new'
    end 

    def update

        title 			= params['contest']['title']
        slugVal 		= create_slug(title)
        final_slug 		= check_slug_available(slugVal, slugVal, 0, contest_id = params[:id])
     
       # abort(params.to_json)
        params['contest']['paramlink'] = final_slug

        @contest = Contest.find_by(id: params[:id])
        if @contest.update(contest_params)

            ############ Images update start #################
            #to delete images 
            if params['contest']['removedimages'].present?
              removedimages_array = params[:contest][:removedimages].split(',')
              if removedimages_array.present?
                Image.where("id IN (?)", removedimages_array).delete_all
              end
            end

            #to update caption of existing images
            if params['contest']['images_attributes_default'].present?
              params['contest']['images_attributes_default'].each do |data_update|
                Image.where('id = ?', data_update[0]).update_all(:caption_image => data_update[1]['caption_image'])  
              end
            end

            ############ Images update end #################

            ############ Video url update start #################

            #to delete video url 
            if params['contest']['removedvideourl'].present?
              removedvideourl_array = params[:contest][:removedvideourl].split(',')
              if removedvideourl_array.present?
                Video.where("id IN (?)", removedvideourl_array).delete_all
              end
            end

            #to update caption of existing video url
            if params['contest']['videos_attributes_default'].present?
              params['contest']['videos_attributes_default'].each do |data_update|
                Video.where('id = ?', data_update[0]).update_all(:caption_video => data_update[1]['caption_video'])  
              end
            end

            ############ Video url update end #################

            ############ sketchfab update start #################

            #to delete Sketchfeb
            if params['contest']['removedsketchfab'].present?
              removedsketchfab_array = params[:contest][:removedsketchfab].split(',')
              if removedsketchfab_array.present?
                Sketchfeb.where("id IN (?)", removedsketchfab_array).delete_all
              end
            end

            #to update caption of existing sketchfebs url
            if params['contest']['sketchfebs_attributes_default'].present?
              params['contest']['sketchfebs_attributes_default'].each do |data_update|
                Sketchfeb.where('id = ?', data_update[0]).update_all(:caption_sketchfeb => data_update[1]['caption_sketchfeb'])  
              end
            end

            ############ sketchfab update end #################

            ############ upload video update start #################

            #to delete upload video 
            if params['contest']['removedUploadVideo'].present?
              removed_upload_video_array = params[:contest][:removedUploadVideo].split(',')
              if removed_upload_video_array.present?
                UploadVideo.where("id IN (?)", removed_upload_video_array).delete_all
              end
            end

            #to update caption of existing upload video
            if params['contest']['upload_videos_attributes_default'].present?
              params['contest']['upload_videos_attributes_default'].each do |data_update|
                UploadVideo.where('id = ?', data_update[0]).update_all(:caption_upload_video => data_update[1]['caption_upload_video'])  
              end
            end

            ############ upload video update end #################

            ############ marmoset update start #################

            #to delete upload video 
            if params['contest']['removedMarmoset'].present?
              removed_marmoset_array = params[:contest][:removedMarmoset].split(',')
              if removed_marmoset_array.present?
                MarmoSet.where("id IN (?)", removed_marmoset_array).delete_all
              end
            end

            #to update caption of existing upload video
            if params['contest']['marmo_sets_attributes_default'].present?
              params['contest']['marmo_sets_attributes_default'].each do |data_update|
                MarmoSet.where('id = ?', data_update[0]).update_all(:caption_marmoset => data_update[1]['caption_marmoset'])
              end
            end

            ############ marmoset update end #################




            #to delete all previous tags
            Tag.where("tagable_id = ? AND tagable_type = 'Contest'", @contest['id']).delete_all

            #to add new tags
            tags_list = params['contest']['tag']['tag']
            tags_list.reject!{|a| a==""}
            tags_list.each do |tag_val|

               Tag.create(
                    tag: tag_val, 
                    tagable_id: @contest['id'], 
                    tagable_type: 'Contest'
                ) 

            end

      

            ############################################
         
            if params[:contest][:crop_x].present?
                @contest.company_logo = @contest.company_logo.resize_and_crop
                @contest.save!
                @contest.company_logo.recreate_versions!
            end
            ############################################

            if params[:contest][:avatar].present?
                 caption_image  = params[:contest][:avatar_caption]
                  my_array = params[:contest][:removedids].split(',')
                 #abort(my_array.inspect)
                 params[:contest][:avatar].each.with_index do |a,index|
                   caption = ''  
                   if caption_image[index].present?
                        caption = caption_image[index]['caption_image']
                   end        


                    if !my_array.include?(index.to_s)  
                         @image = @contest.images.create!(:image => a[:image],:caption_image => caption)
                    end
                   
                 end
            end  
           # LatestActivity.create(user_id: current_user.id, artist_id: current_user.id, post_id: @contest['id'], activity_type: 'updated', section_type: 'Contest')  
            ############################################
            redirect_to contests_path, notice: 'Contest Successfully Updated.'

        else
            render 'new'
        end    
	end 

	def save_like
		#abort(params.to_json)
          contest_id     = params[:contest_id]
          artist_id      = params[:artist_id]
          user_id        = current_user.id
          is_like_exist  = ContestLike.where(user_id: user_id, post_id: contest_id, post_type: 'Contest').first
          result        = ''
          contestrecord  = Contest.where(id: contest_id).first

          activity_type = ''
          if is_like_exist.present?
                activity_type = 'disliked'
                ContestLike.where(user_id: user_id, post_id: contest_id, post_type: 'Contest').delete_all 

                newlike_count  =  (contestrecord.like_count == 0) ? 0 : contestrecord.like_count - 1
                contestrecord.update(like_count: newlike_count) 

                result  = {'res' => 0, 'message' => 'Contest has disliked'}
          else
                activity_type = 'liked'
                ContestLike.create(user_id: user_id, artist_id: artist_id, post_id: contest_id, post_type: 'Contest')  
                
                newlike_count  =  contestrecord.like_count + 1
                contestrecord.update(like_count: newlike_count) 

                result  = {'res' => 1, 'message' => 'Contest has liked'}

          end 

          #LatestActivity.create(user_id: user_id,  artist_id: artist_id,  post_id: contest_id, activity_type: activity_type, section_type: 'Contest')  

          render json: result, status: 200       
    end  

     def check_save_like
          contest_id     = params[:contest_id]
          user_id        = current_user.id
          is_like_exist  = ContestLike.where(user_id: user_id, post_id: contest_id, post_type: 'Contest').first
          result = ''
          if is_like_exist.present?
                result  = {'res' => 1, 'message' => 'Contest has already liked'}
          else
                result  = {'res' => 0, 'message' => 'Contest has not liked'}
          end 
         
          render json: result, status: 200       
    end  


     def save_view_count
#abort(params.to_json)
       if params[:contest_id].present?
            contest_id      = params[:contest_id]
            record          = Contest.where("id = ?",contest_id).first

            prevoius_view_count   = record.view_count
            newview_count         =  prevoius_view_count + 1
            
            record.update(view_count: newview_count) 
       end     
       render json: {'res' => 0, 'message' => 'success'}, status: 200       
    end  



	def show
        @contest    = Contest.find_by(paramlink: params[:paramlink])
        @collection = Collection.new
        @report     = Report.new
        #render 'show'
        
    end  



    def get_winner_list
       
          result = Contest.where("winner_type IN (1,2,3)").order('id DESC')
          render :json => result.to_json(:include => [:user,:images]), status: 200
    end   

    def get_honour_list
          result = Contest.where("winner_type IN (4)").order('id DESC')
          render :json => result.to_json(:include => [:user, :images]), status: 200

    end  

     def make_trash
       # abort(params.to_json)
         paramlink             =  params[:paramlink]
         @is_contest_exist     =  Contest.where(paramlink: paramlink).first
         #abort(@is_contest_exist.to_json)
         if @is_contest_exist.present?
            Contest.where('id = ?',@is_contest_exist.id).update_all(:is_trash => 1)  
            flash[:notice] = 'Contest has successfully trashed.'
            redirect_to contests_path
         end
          
    end   


	def get_contest_post_list
    #abort(params.to_json)
     # abort(params.to_json)
        conditions = "user_id=#{current_user.id} AND is_admin != 'Y'  AND is_trash = 0 "

        if(params[:post_type_category_id] && params[:post_type_category_id] != '')
          conditions += ' AND post_type_category_id=' + params[:post_type_category_id]
        end 

        if(params[:medium_category_id] && params[:medium_category_id] != '')
          conditions += ' AND medium_category_id=' + params[:medium_category_id]
        end 

        result = Contest.where(conditions).order('id DESC')

        render :json => result.to_json(:include => [:category, :medium_category]), status: 200

  end


    def get_all_submission
    #abort(params.to_json)
     # abort(params.to_json)
        conditions = "is_trash = 0 "

        if(params[:browse_submission_By] && params[:browse_submission_By] != '')
              if params[:browse_submission_By] == "popular"
                    result = Contest.where(conditions).order('like_count DESC, id DESC')
              
              elsif params[:browse_submission_By] == "following"    
                    result = Contest.where(conditions).order('follow_count DESC, id DESC')
              
              elsif params[:browse_submission_By] == "mysubmission"      
                   result = Contest.where("is_admin = ? AND user_id = ?", 'N',current_user.id).order('id DESC')
              end  

         else
                 result = Contest.where(conditions).order('id DESC')
            
        end 

        render :json => result.to_json(:include => [:user, :images]), status: 200

  end


  def follow_contest
          contest_id        = params[:contest_id]
          user_id           = current_user.id
          is_follow_exist   = ContestFollow.where(user_id: user_id, contest_id: contest_id, post_type: '').first
          result = ''
          
          contestrecord     = Contest.where(id: contest_id).first

          if is_follow_exist.present?
                ContestFollow.where(user_id: user_id, contest_id: contest_id, post_type: '').delete_all 

                newfollow_count  =  (contestrecord.follow_count == 0) ? 0 : contestrecord.follow_count - 1
                contestrecord.update(follow_count: newfollow_count) 

                result  = {'res' => 0, 'message' => 'Contest Not Follow'}
          else
                ContestFollow.create(user_id: user_id, contest_id: contest_id, post_type: '')  

                newfollow_count  =  contestrecord.follow_count + 1
                contestrecord.update(follow_count: newfollow_count) 

                result  = {'res' => 1, 'message' => 'Contest Follow'}

          end 


          render json: result, status: 200       
    end  

     def check_follow_contest
          contest_id     = params[:contest_id]
          user_id        = current_user.id
          is_like_exist  = ContestFollow.where(user_id: user_id, contest_id: contest_id, post_type: '').first
          result = ''
          if is_like_exist.present?
                result  = {'res' => 1, 'message' => 'Contest already followed'}
          else
                result  = {'res' => 0, 'message' => 'Contest not followed'}
          end 

          render json: result, status: 200       
    end  




    private
        def contest_params
            params.require(:contest).permit(:user_id, :title, :description, :post_type_category_id, :medium_category_id, {:subject_matter_id => []}, {:team_member => []}, {:challenge => []}, :has_adult_content, {:software_used => []}, :paramlink, :is_admin, :use_tag_from_previous_upload, :is_featured, :show_on_cgmeetup, :show_on_website, :schedule_time , :zoom_w, :zoom_h, :zoom_x, :zoom_y, :drag_x, :drag_y, :rotation_angle, :crop_x, :crop_y, :crop_w, :crop_h, :company_logo, :publish, :visibility, :is_save_to_draft, :tags_attributes => [:id, :tag, :tagable_id, :tagable_type, :_destroy, :tmp_tag, :tag_cache], :images_attributes => [:id,:image,:caption_image,:imageable_id,:imageable_type, :_destroy,:tmp_image,:image_cache], :videos_attributes => [:id,:video,:caption_video,:videoable_id,:videoable_type, :_destroy,:tmp_image,:video_cache], :sketchfebs_attributes => [:id,:sketchfeb,:sketchfebable_id,:sketchfebable_type, :_destroy,:tmp_sketchfeb,:sketchfeb_cache,:caption_sketchfeb], :marmo_sets_attributes => [:id,:marmoset,:marmosetable_id,:marmosetable_type, :_destroy,:tmp_image,:marmoset_cache,:caption_marmoset], :upload_videos_attributes => [:id,:uploadvideo,:caption_upload_video,:uploadvideoable_id,:uploadvideoable_type, :_destroy,:tmp_image,:uploadvideo_cache])
        end

        def check_slug_available(slugVal, newSlugVal, i, contest_id)

            result = Contest.where('id != ? AND paramlink = ?', contest_id, newSlugVal).count

            if result == 0
                return newSlugVal
            else
                i = i + 1
                newSlugVal = slugVal + '-' + i.to_s
                check_slug_available(slugVal, newSlugVal, i, contest_id)
            end  

        end 







end
