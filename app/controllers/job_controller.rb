class JobController < ApplicationController
  
   before_action :authenticate_user!, only: [:new, :crete, :edit, :update, :get_job_list, :count_user_job_post]

  def index
  	authenticate_user!
  end

  def listing_index

      @jobcategory = JobCategory.all
    
  end

  def new
      @job = Job.new
      @jobcategory = JobCategory.all
  end  

   def edit
      @jobcategory = JobCategory.all
      @job = Job.find_by(paramlink: params[:paramlink])

      render 'new'
  end  


  def get_job_list
    
        conditions = "user_id=#{current_user.id} AND is_admin != 'Y'"

        if(params[:job_type] && params[:job_type] != '')
          conditions += " AND job_type='" + params[:job_type] + "'"
        end 

        if(params[:job_category] && params[:job_category] != '')
           conditions += " AND job_category::jsonb ?| array['" + params[:job_category] + "'] "
        end 



        if(params[:view]) 
          if (params[:view] == 'featured')
            conditions += ' AND is_featured=TRUE  AND is_trash = 0'
          elsif (params[:view] == 'published')
            conditions += ' AND publish=1  AND is_trash = 0'
          elsif (params[:view] == 'drafts')
            conditions += ' AND is_save_to_draft=1  AND is_trash = 0'
          elsif (params[:view] == 'trash')
            conditions += ' AND is_trash=1'
          end
        end

        
       # abort(conditions.to_json)
        result = Job.where(conditions).order('id DESC')
        #abort(result.to_json)
        render :json => result.to_json, status: 200

  end

  def count_user_job_post

        conditions = "user_id=#{current_user.id} AND is_admin != 'Y'"

        r_data = Job.where(conditions)

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



    def make_trash
         #abort(params.to_json)
         paramlink             =  params[:paramlink]
         @is_job_exist     =  Job.where(paramlink: paramlink).first
        # abort(@is_gallery_exist.to_json)
         if @is_job_exist.present?
            Job.where('id = ?',@is_job_exist.id).update_all(:is_trash => 1)  
            flash[:notice] = 'Job has successfully trashed.'
            redirect_to index_job_path
         end
          
    end  





  def create


        title = params['job']['title']
        slugVal = create_slug(title)

        final_slug = check_slug_available(slugVal, slugVal, 0, job_id = 0)

        #abort(params['gallery']['tag']['tag'].to_json)

        params['job']['paramlink'] = final_slug
        params['job']['user_id']   = current_user.id.to_s
        params['job']['is_admin']  = 'N'

        if params[:job][:company_name].present?
            companyexist = Company.where("name=?", params[:job][:company_name]).count
            if companyexist < 1
                company_data =  Company.create(name: params[:job][:company_name], user_id: current_user.id)
                params['job']['company_id']   = company_data.id
                params['job']['company_name'] = params[:job][:company_name]
            end    

        end  



        if params['commit'] == 'Publish'
            params['job']['is_save_to_draft'] = 0

        elsif params['commit'] == 'SaveDraft'
            params['job']['is_save_to_draft'] = 1
        end 

     #  caption_image  = params[:gallery][:avatar_caption]
     #  abort(caption_image[2].present?)
     # abort(params.inspect)


        @job = Job.new(job_params)

        if @job.save

            
           
            tags_list = params['job']['tag']['tag']
            tags_list.reject!{|a| a==""}

            tags_list.each do |tag_val|

                Tag.create(
                    tag: tag_val, 
                    tagable_id: @job['id'], 
                    tagable_type: 'Job'
                )

            end

             #abort(@gallery.to_json)   

            ############################################
         
            if params[:job][:crop_x].present?
                @job.company_logo = @job.company_logo.resize_and_crop
                @job.save!
                @job.company_logo.recreate_versions!
            end
            ############################################

            if params[:job][:avatar].present?
                 caption_image  = params[:job][:avatar_caption]
                  my_array = params[:job][:removedids].split(',')
                 #abort(my_array.inspect)
                 params[:job][:avatar].each.with_index do |a,index|
                   caption = ''  
                   if caption_image[index].present?
                        caption = caption_image[index]['caption_image']
                   end        


                    if !my_array.include?(index.to_s)  
                         @image = @job.images.create!(:image => a[:image],:caption_image => caption)
                    end
                   
                 end
            end  

           #LatestActivity.create(user_id: current_user.id, artist_id: current_user.id, post_id: @job['id'], activity_type: 'created', section_type: 'Gallery')  
            ############################################
            redirect_to index_job_path, notice: 'Job Successfully Created.'

        else
            render 'new'
        end    

      #abort(@gallery.errors.to_json)
    

    end 

    def update
    #abort(params.to_json)
    @job = Job.find_by(paramlink: params[:paramlink])
    #abort(@job.id.to_s)
        title = params['job']['title']

        slugVal = create_slug(title)

        final_slug = check_slug_available(slugVal, slugVal, 0, job_id = @job.id.to_s)

        #abort(params['gallery']['tag']['tag'].to_json)

        params['job']['paramlink'] = final_slug


        if params['commit'] == 'Publish'
            params['job']['is_save_to_draft'] = 0

        elsif params['commit'] == 'SaveDraft'
            params['job']['is_save_to_draft'] = 1
        end

        if params[:job][:company_name].present?
            companyexist = Company.where("name=?", params[:job][:company_name]).count
            if companyexist < 1
                company_data =  Company.create(name: params[:job][:company_name], user_id: current_user.id)
                params['job']['company_id']   = company_data.id
                params['job']['company_name'] = params[:job][:company_name]
            end    

        end  

        

    
#abort(params.to_json)
        
        if @job.update(job_params)

            ############ Images update start #################
            #to delete images 
            if params['job']['removedimages'].present?
              removedimages_array = params[:job][:removedimages].split(',')
              if removedimages_array.present?
                Image.where("id IN (?)", removedimages_array).delete_all
              end
            end

            #to update caption of existing images
            if params['job']['images_attributes_default'].present?
              params['job']['images_attributes_default'].each do |data_update|
                Image.where('id = ?', data_update[0]).update_all(:caption_image => data_update[1]['caption_image'])  
              end
            end

            ############ Images update end #################

            ############ Video url update start #################

            #to delete video url 
            if params['job']['removedvideourl'].present?
              removedvideourl_array = params[:job][:removedvideourl].split(',')
              if removedvideourl_array.present?
                Video.where("id IN (?)", removedvideourl_array).delete_all
              end
            end

            #to update caption of existing video url
            if params['job']['videos_attributes_default'].present?
              params['job']['videos_attributes_default'].each do |data_update|
                Video.where('id = ?', data_update[0]).update_all(:caption_video => data_update[1]['caption_video'])  
              end
            end

            ############ Video url update end #################

            ############ sketchfab update start #################

            #to delete Sketchfeb
            if params['job']['removedsketchfab'].present?
              removedsketchfab_array = params[:job][:removedsketchfab].split(',')
              if removedsketchfab_array.present?
                Sketchfeb.where("id IN (?)", removedsketchfab_array).delete_all
              end
            end

            #to update caption of existing sketchfebs url
            if params['job']['sketchfebs_attributes_default'].present?
              params['job']['sketchfebs_attributes_default'].each do |data_update|
                Sketchfeb.where('id = ?', data_update[0]).update_all(:caption_sketchfeb => data_update[1]['caption_sketchfeb'])  
              end
            end

            ############ sketchfab update end #################

            ############ upload video update start #################

            #to delete upload video 
            if params['job']['removedUploadVideo'].present?
              removed_upload_video_array = params[:job][:removedUploadVideo].split(',')
              if removed_upload_video_array.present?
                UploadVideo.where("id IN (?)", removed_upload_video_array).delete_all
              end
            end

            #to update caption of existing upload video
            if params['job']['upload_videos_attributes_default'].present?
              params['job']['upload_videos_attributes_default'].each do |data_update|
                UploadVideo.where('id = ?', data_update[0]).update_all(:caption_upload_video => data_update[1]['caption_upload_video'])  
              end
            end

            ############ upload video update end #################

            ############ marmoset update start #################

            #to delete upload video 
            if params['job']['removedMarmoset'].present?
              removed_marmoset_array = params[:job][:removedMarmoset].split(',')
              if removed_marmoset_array.present?
                MarmoSet.where("id IN (?)", removed_marmoset_array).delete_all
              end
            end

            #to update caption of existing upload video
            if params['job']['marmo_sets_attributes_default'].present?
              params['job']['marmo_sets_attributes_default'].each do |data_update|
                MarmoSet.where('id = ?', data_update[0]).update_all(:caption_marmoset => data_update[1]['caption_marmoset'])
              end
            end

            ############ marmoset update end #################




            #to delete all previous tags
            Tag.where("tagable_id = ? AND tagable_type = 'Job'", @job['id']).delete_all

            #to add new tags
            tags_list = params['job']['tag']['tag']
            tags_list.reject!{|a| a==""}
            tags_list.each do |tag_val|

               Tag.create(
                    tag: tag_val, 
                    tagable_id: @job['id'], 
                    tagable_type: 'Job'
                ) 

            end

             #abort(@gallery.to_json)   

            ############################################
          
            if params[:job][:crop_x].present?
                @job.company_logo = @job.company_logo.resize_and_crop
                @job.save!
                @job.company_logo.recreate_versions!
            end
            ############################################

            if params[:job][:avatar].present?
                 caption_image  = params[:job][:avatar_caption]
                 my_array = params[:job][:removedids].split(',')
                 #abort(my_array.inspect)
                 params[:job][:avatar].each.with_index do |a,index|
                   caption = ''  
                   if caption_image[index].present?
                        caption = caption_image[index]['caption_image']
                   end        


                    if !my_array.include?(index.to_s)  
                         @image = @job.images.create!(:image => a[:image],:caption_image => caption)
                    end
                   
                 end
            end  
            #LatestActivity.create(user_id: current_user.id, artist_id: current_user.id, post_id: @gallery['id'], activity_type: 'updated', section_type: 'Gallery')  
            ############################################
            redirect_to index_job_path, notice: 'Job Successfully Updated.'

        else
            render 'new'
        end    

      #abort(@gallery.errors.to_json)
    

    end 





  def job_home    

  	conditions = "visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))"
  	@result = Job.where(conditions).order('id DESC').page(params[:page]).per(10)
  	@final_result = JSON.parse(@result.to_json(:include => [:company, :country]))
    @job_type = JobCategory.all
    @country_detail = Country.all
    
    @contracttype  = JobCategory.all
    @catgorytype   = CategoryType.all
    @featured_jobs = Job.where("is_featured = ?", true).order('id DESC').limit(5)
   # abort( @featured_jobs.to_json)


  end

  def get_job_home_list

    #conditions = "visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))"
    conditions = ""
   
    if(params[:country_id] && params[:country_id] != '')
          conditions += ' AND country_id=' + params[:country_id]
    end 

    if(params[:job_type] && params[:job_type] != '')
          conditions += " AND job_type='" + params[:job_type] + "'"
    end 

    if(params[:job_category] && params[:job_category] != '')
          conditions +=  " AND job_category::jsonb ?| array['" + params[:job_category] + "'] " 
    end 

    if(params[:work_remotely] && params[:work_remotely] != '')
          conditions += " AND work_remotely=" + params[:work_remotely]
    end 

    if(params[:relocation_asistance] && params[:relocation_asistance] != '')
          conditions += " AND relocation_asistance=" + params[:relocation_asistance]
    end 

     if(params[:user_id] && params[:user_id] != '')
          conditions += " AND is_admin='N' AND user_id=" + params[:user_id]
    end 


    #abort(conditions.to_json)

    orderby = 'DESC'
    if(params[:order] && params[:order] != '') 
              orderby = params[:order]
    end
    


    @result = Job.where(conditions).order('id '+ orderby)
    #@final_result = JSON.parse(@result.to_json(:include => [:company, :country]))
    render :json =>  @result.to_json(:include => [:company, :country]), status: 200
  

  end


  def get_company_job_list

    conditions = "visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))"
   
    if(params[:country_id] && params[:country_id] != '')
          conditions += ' AND country_id=' + params[:country_id]
    end 

    if(params[:job_type] && params[:job_type] != '')
          conditions += " AND job_type='" + params[:job_type] + "'"
    end 

    if(params[:job_category] && params[:job_category] != '')
          conditions +=  " AND job_category::jsonb ?| array['" + params[:job_category] + "'] " 
    end 

    if(params[:work_remotely] && params[:work_remotely] != '')
          conditions += " AND work_remotely=" + params[:work_remotely]
    end 

    if(params[:relocation_asistance] && params[:relocation_asistance] != '')
          conditions += " AND relocation_asistance=" + params[:relocation_asistance]
    end 

     if(params[:user_id] && params[:user_id] != '')
          conditions += " AND is_admin='N' AND user_id=" + params[:user_id]
    end 


    #abort(conditions.to_json)

    orderby = 'DESC'
    if(params[:order] && params[:order] != '') 
              orderby = params[:order]
    end

    @result = Job.where(conditions).order('id '+ orderby)
    render :json =>  @result.to_json(:include => [:company, :country, :images]), status: 200
  

  end

  def update_user_image

  	authenticate_user!
  	params[:user] ||= {'submit'=> true}
  	if params[:user] == {'submit'=> true}
	  	flash[:error] = "Image can't be blank."
	  end
  	@user = current_user
  	
  	if @user.update_attributes(user_params)
  		if params[:commit] == "UpdateProfilePhoto"
  			flash[:notice] = "Profile photo updated successfully."
  		elsif params[:commit] == "UpdateCoverArt"
  			flash[:notice] = "Cover art updated successfully."	
  		else
  			flash[:notice] = "Successfully updated."
  		end	
      #redirect_to request.referer
    else
      #render 'index'
    end

    redirect_to request.referer
	  
  end	

  def remove_cover_art

  	authenticate_user!
  	@user = current_user
  	
  	@user.remove_cover_art_image!	
  	@user.save

    flash[:notice] = "Cover art removed successfully."		
    redirect_to request.referer
	  
  end
  
  def job_post  	
  end

  def applied_job
      paramlink         = params[:paramlink]
      @result           = Job.where("paramlink = ? ", paramlink).first
      @similar_jobs     = Job.where("paramlink != ? ", paramlink).order('random()').limit(4)
      apply_type        = @result.apply_type
      @success_message  = ""
      #abort(@result.to_json)
      if apply_type == "email"
          sender_email      = current_user.email
          receiver_email    = @result.apply_email
          job_title         = @result.title
          UserMailer.job_application_email(sender_email,receiver_email,job_title,current_user).deliver_later
          @success_message  = "Thank you for applying. We will get back to you shortly"  
      elsif apply_type == "url"
          redirect_to @result.apply_url
      else
          @success_message  = @result.apply_instruction  
      end 

  end  

  def save_job_view_count

       if params[:paramlink].present?
            paramlink       = params[:paramlink]
            record          = Job.where("paramlink = ?",paramlink).first
           
            prevoius_view_count   = record.view_count
            newview_count         =  prevoius_view_count + 1
            
            record.update(view_count: newview_count) 
            render json: {'res' => 1, 'message' => 'success'}, status: 200
       end     
    end  
  
 
  def apply_job

    @job_id = params[:id]

    #conditions = "visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))"
    @result = Job.where("paramlink = ?", @job_id).first

    if @result.present?

      @result.software_expertise.reject!{|a| a==""}
      @result.skill.reject!{|a| a==""}

      @software_expertise = SoftwareExpertise.where('id IN (?)', @result.software_expertise)
      @job_skills = JobSkill.where('id IN (?)', @result.skill)

      similar_job_conditions = "visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone)) AND paramlink !='" + @job_id  + "'"

      @similar_jobs = Job.where(similar_job_conditions).order('random()').limit(4)

    else
        redirect_to jobs_path, notice: 'Job not available !'
    end

  end 
  def follow_job
        
          job_id        = params[:job_id]
          company_id        = params[:company_id]
          user_id          = current_user.id
          is_follow_exist  = JobFollow.where(user_id: user_id, job_id: job_id, company_id: company_id).first
          result = ''
          
          userrecord       = Job.where(id: job_id).first

          if is_follow_exist.present?
                JobFollow.where(user_id: user_id, job_id: job_id, company_id: company_id).delete_all 
                
                newfollow_count  =  (userrecord.follow_count == 0) ? 0 : userrecord.follow_count - 1
                userrecord.update(follow_count: newfollow_count) 

                result  = {'res' => 0, 'message' => 'Job Not Follow'}
          else
                JobFollow.create(user_id: user_id, job_id: job_id, company_id: company_id)
                newfollow_count  =  userrecord.follow_count + 1
                userrecord.update(follow_count: newfollow_count) 

                result  = {'res' => 1, 'message' => 'Job Follow'}
          end 
          render json: result, status: 200    
             
  end
  def check_follow_job
          job_id     = params[:job_id]
          company_id     = params[:company_id]
          user_id        = current_user.id
          is_like_exist  = JobFollow.where(user_id: user_id, job_id: job_id, company_id: company_id).first
          result = ''
          if is_like_exist.present?
                result  = {'res' => 1, 'message' => 'Job already followed'}
          else
                result  = {'res' => 0, 'message' => 'Job not followed'}
          end 

          render json: result, status: 200       
    end  

  def job_category
  end

  def job_company_list_on_map

    @job_type = JobCategory.all
    @country_detail = Country.all
    
    @contracttype  = JobCategory.all
    @catgorytype   = CategoryType.all

  end

  def job_list_on_map

    conditions      = "visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))"
    @result         = Job.where(conditions).order('id DESC').page(params[:page]).per(10)
    @final_result   = JSON.parse(@result.to_json(:include => [:company, :country]))
    @job_type       = JobCategory.all
    @country_detail = Country.all
    
    @contracttype   = JobCategory.all
    @catgorytype     = CategoryType.all
    @featured_jobs  = Job.where("is_featured = ?", true).order('id DESC').limit(5)


  end



  private
	 def job_params
            params.require(:job).permit(:is_spam, :title,:user_id,:is_admin, :paramlink,{:package_id => []},:description,:show_on_cgmeetup,:show_on_website,:company_url, :company_id, :schedule_time, :job_type, :from_amount, :to_amount, {:job_category => []} , :application_email_or_url, :country_id, :city, :state,  :work_remotely, :relocation_asistance,:closing_date, {:skill => []} , {:software_expertise => []} , :tags, :use_tag_from_previous_upload, :is_featured, :status, :apply_type,:apply_instruction,:apply_email,:apply_url,:is_save_to_draft,:visibility,:publish,:company_logo, {:where_to_show => []} , :images_attributes => [:id,:image,:caption_image,:imageable_id,:imageable_type, :_destroy,:tmp_image,:image_cache], :videos_attributes => [:id,:video,:caption_video,:videoable_id,:videoable_type, :_destroy,:tmp_image,:video_cache], :upload_videos_attributes => [:id,:uploadvideo,:caption_upload_video,:uploadvideoable_id,:uploadvideoable_type, :_destroy,:tmp_image,:uploadvideo_cache], :sketchfebs_attributes => [:id,:sketchfeb,:sketchfebable_id,:sketchfebable_type, :_destroy,:tmp_sketchfeb,:sketchfeb_cache], :marmo_sets_attributes => [:id,:marmoset,:marmosetable_id,:marmosetable_type, :_destroy,:tmp_image,:marmoset_cache], :company_attributes => [:id,:name], :zip_files_attributes => [:id,:zipfile, :zipfileable_id,:zipfileable_type, :_destroy,:tmp_zipfile,:zipfile_cache,:zip_caption],:tags_attributes => [:id,:tag,:tagable_id,:tagable_type, :_destroy,:tmp_tag,:tag_cache])


   end

  def check_slug_available(slugVal, newSlugVal, i, job_id)

            result = Job.where('id != ? AND paramlink = ?', job_id, newSlugVal).count

            if result == 0
                return newSlugVal
            else
                i = i + 1
                newSlugVal = slugVal + '-' + i.to_s
                check_slug_available(slugVal, newSlugVal, i, job_id)
            end  

        end 


end
