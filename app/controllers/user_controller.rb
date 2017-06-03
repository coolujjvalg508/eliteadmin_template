class UserController < ApplicationController
    before_action :find_associated_data, only: [:edit_profile, :update]
    before_action :authenticate_user!, only: [:save_qb_data, :user_setting, :user_portfolio, :notification, :dashboard, :bookmark, :edit_profile, :user_jobs,:update, :user_profile_info, :user_like, :get_user_likes,:connection_followers,:get_connection_followers, :connection_following, :get_connection_following,:all_activity]
 

    def dashboard
       
        @like_count =  Gallery.where("is_trash = ? AND is_admin = ? AND user_id = ? AND status = ?", 0, 'N', current_user.id, 1).sum(:like_count)
        @view_count =  Gallery.where("is_trash = ? AND is_admin = ? AND user_id = ? AND status = ?", 0, 'N', current_user.id, 1).sum(:view_count)
        @comment_count =  Gallery.where("is_trash = ? AND is_admin = ? AND user_id = ? AND status = ?", 0, 'N', current_user.id, 1).sum(:comment_count)
        @user_view_count =  User.where("id = ? AND is_deleted = ?", current_user.id,0).sum(:view_count)
        
        @transaction =  PurchasedProduct.joins(:download).where("downloads.user_id = ? AND downloads.is_admin = 'N' AND status = ?", @current_user.id, 1).pluck(:transaction_history_id)
        
        @allpostlikerecords      =   PostLike.where(artist_id: current_user.id).order('id desc').limit(6)

        allgalleryrecords        =   Gallery.where('is_trash = ? AND is_admin=? AND user_id=? AND status=?',0,'N',current_user.id,1).order('id desc').limit(6).pluck(:id)

         @allpostcommentrecords  =   PostComment.where(post_id: allgalleryrecords).order('id desc').limit(6)
    
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

              similar_job_conditions = "visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone)) AND paramlink !='" + @job_id  + "'  AND user_id = #{current_user.id} AND is_admin = 'N' "

              @similar_jobs = Job.where(similar_job_conditions).order('random()').limit(4)

            else
                redirect_to jobs_path, notice: 'Job not available !'
            end

    end 



    def user_stats

        artist_id   = params[:id]

        @artist_data             =  User.where("username = ? AND is_deleted = ?", artist_id,0).first
       
        @like_count              =  Gallery.where("is_trash = ? AND is_admin = ? AND user_id = ? AND status = ?", 0, 'N', @artist_data.id, 1).sum(:like_count)
        @view_count              =  Gallery.where("is_trash = ? AND is_admin = ? AND user_id = ? AND status = ?", 0, 'N', @artist_data.id, 1).sum(:view_count)
        @comment_count           =  Gallery.where("is_trash = ? AND is_admin = ? AND user_id = ? AND status = ?", 0, 'N', @artist_data.id, 1).sum(:comment_count)
        @user_view_count         =  User.where("id = ? AND is_deleted = ?", @artist_data.id,0).sum(:view_count)

        
        @allpostlikerecords      =  PostLike.where(artist_id: @artist_data.id).order('id desc').limit(6)

        allgalleryrecords        =  Gallery.where('is_trash = ? AND is_admin=? AND user_id=? AND status=?',0,'N',@artist_data.id,1).order('id desc').limit(6).pluck(:id)

        @allpostcommentrecords   =  PostComment.where(post_id: allgalleryrecords).order('id desc').limit(6)

    end  


    def get_stats

        user_id = ''
        if params[:artist_id].present?
            user_id = params[:artist_id]
        else
            user_id = current_user.id
        end    

        gallery_past_30_days     = Gallery.where('created_at > ? AND is_trash = ? AND is_admin=? AND user_id=? AND status=?', 30.days.ago,0,'N',user_id , 1)
        render :json =>  gallery_past_30_days.to_json(:include => [:post_like => {:include => [:user]}]), status: 200 
        
    end 
        
    def signup

    end

    def forgotpassword
    end

    def all_activity
            following_records     =   Follow.where("user_id = ? AND is_admin= ? ",current_user.id,'N')
            following_ids   =   []
            following_records.each_with_index do |value , index|
                following_ids[index]   =  value.artist_id
            end 

           @latestactivity_data    =   LatestActivity.where("user_id IN (?)  AND is_admin= ? ",following_ids, 'N').page(params[:page]).per(10) 
    end
 
    def message

    end

    def index
    end

    def add
    end

    def profile
    end

    def feed
    end

    def trending
    end

    def following
    end

    def followers
    end

    def bookmark
    end

    def notification
        @notification_data = Notification.where(artist_id: current_user.id).order('id DESC').page(params[:page]).per(10)
    end


    def update_read_notification

            current_login_user = current_user.id
            Notification.where("artist_id = ? ", current_login_user).update_all(:is_read => 1)
            render :json => {'message': 'success','result':1}, status: 200 
    end    

    def save_qb_data
        @user = User.find_by(id: params[:user_id]) 
        @user.update(qb_id: params[:qb_id],qb_password: params[:qb_password])
        render json: {message: 'ok',status: '200'}
    end
    
    



    def browse_all_artist
    end
    



    def connection_followers
    
    end


    def connection_following
    end 

     def get_connection_followers
        # @follower      = Follow.where('artist_id = ?', current_user).page(params[:page]).per(10)

        orderby = 'DESC'
        if(params[:order] && params[:order] != '') 
                orderby = params[:order]
        end

        @follower      = Follow.where('artist_id = ?', current_user).order('id '+ orderby)

         final_data = []
         @follower.each_with_index do |data, index| 
            res     =   get_artist_like(data.user.id)
            final_data[index]  = {'data': data,'user': data.user,'country_name': data.user.country.name,'like_res': res}
         end
        # abort(final_data.to_json)
        render :json => final_data.to_json, status: 200 



    end


    def get_connection_following
       

        orderby = 'DESC'
        if(params[:order] && params[:order] != '') 
                orderby = params[:order]
        end

        @following      = Follow.where('user_id = ?', current_user).order('id '+ orderby)

         final_data = []
         @following.each_with_index do |data, index| 
            #abort(data.user.to_json)
            res     =   get_artist_like(data.artist.id)
            final_data[index]  = {'data': data,'user': data.artist,'country_name': data.artist.country.name,'like_res': res}
         end
        # abort(final_data.to_json)
        render :json => final_data.to_json, status: 200 


       # render json: following, status: 200  
    end

    def edit_profile
        @user = current_user

    end

    def update
        #abort(params.to_json)

           #abort(params["user"]["professional_experiences"].to_json)
        params[:user] ||= {'submit'=> true}
        if params[:user] == {'submit'=> true}
            flash[:error] = "Image can't be blank."
        end


        if params[:commit] == "ProfessionalExperience"    

            ProfessionalExperience.where(user_id: current_user.id).delete_all

            if params["user"]["professional_experiences"].present?

                professional_experiences = params["user"]["professional_experiences"]

                professional_experiences.each_with_index do |d, index| 

                    ProfessionalExperience.create(
                        user_id: current_user.id, 
                        company_id: d[1]['company_id'], 
                        company_name: d[1]['company_name'], 
                        title: d[1]['title'], 
                        location: d[1]['location'], 
                        from_month: d[1]['from_month'],
                        from_year: d[1]['from_year'],
                        to_month: d[1]['to_month'],
                        to_year: d[1]['to_year'],
                        currently_worked: d[1]['currently_worked'],
                        description: d[1]['description']
                    )

                end
            end

            flash[:notice] = "Professional experiences updated successfully."   
            redirect_to edit_profile_path   

        elsif params[:commit] == "ProductionExperience"    

            ProductionExperience.where(user_id: current_user.id).delete_all

            if params["user"]["production_experiences"].present?

                production_experiences = params["user"]["production_experiences"]

                production_experiences.each_with_index do |d, index| 

                    ProductionExperience.create(
                        user_id: current_user.id, 
                        production_title: d[1]['production_title'], 
                        release_year: d[1]['release_year'], 
                        production_type: d[1]['production_type'], 
                        your_role: d[1]['your_role'], 
                        company: d[1]['company']
                    )

                end
            end

            flash[:notice] = "Production experiences updated successfully."   
            redirect_to edit_profile_path  

        elsif params[:commit] == "EducationExperience"    

            EducationExperience.where(user_id: current_user.id).delete_all

            if params["user"]["education_experiences"].present?

                education_experiences = params["user"]["education_experiences"]

                education_experiences.each_with_index do |d, index| 

                    EducationExperience.create(
                            user_id: current_user.id, 
                            school_name: d[1]['school_name'], 
                            field_of_study: d[1]['field_of_study'], 
                            month_val: d[1]['month_val'], 
                            year_val: d[1]['year_val'], 
                            description: d[1]['description']
                    )

                end
            end

            flash[:notice] = "Education experiences updated successfully."   
            redirect_to edit_profile_path                  

        else

            @user = current_user

            if @user.update_attributes(user_params)
                if params[:commit] == "BasicInformation"
                    unless @user.email == params[:user][:email]
                        flash[:notice] = "Profile updated successfully.You will receive an email with instructions for how to confirm your new email address in a few minutes."
                    else
                        flash[:notice] = "Basic information updated successfully."
                    end

                elsif params[:commit] == "ProfessionalSummary"    
                    flash[:notice] = "Professional summary updated successfully."

                elsif params[:commit] == "DemoReel"    
                    flash[:notice] = "Demo reel updated successfully."   

                elsif params[:commit] == "Skills"    
                    flash[:notice] = "Skills updated successfully."

                elsif params[:commit] == "SocialMedia"    
                    flash[:notice] = "Contact & social media details updated successfully." 

                elsif params[:commit] == "ContactInformation"    
                    flash[:notice] = "Contact information updated successfully."               
                    
                else
                    flash[:notice] = "Successfully updated."
                end 

                redirect_to edit_profile_path
            else
                render 'edit_profile'
            end
        end


    end    

    def join_challenge
    end

    def user_followers
    end

    def user_following
    end

    def connection

    end   

    def user_like
    end

    def get_user_likes

        orderby = 'DESC'
        if(params[:order] && params[:order] != '') 
                orderby = params[:order]
        end
         @userlike  =  PostLike.where('user_id = ?', current_user).order('id '+ orderby)

         final_data = []
         @userlike.each_with_index do |data, index| 
             #  abort( data.gallery.to_json)
            final_data[index]  = {'gallery': data.gallery,'images': data.gallery.images,'videos': data.gallery.videos,'upload_videos': data.gallery.upload_videos,'marmo_sets': data.gallery.marmo_sets,'sketchfebs': data.gallery.sketchfebs}
         end
        render :json => final_data, status: 200
    end

    def user_profile_info


        @professional_experiences = ProfessionalExperience.where('user_id = ? ', current_user)
        @education_experiences = EducationExperience.where('user_id = ? ', current_user)
        @production_experiences = ProductionExperience.where('user_id = ? ', current_user)

    end

    def user_jobs
            @job_type = JobCategory.all
    end

    def other_user_profile
        #abort(params.to_json)
        artist_id           =    params[:id]
       # abort(params.to_json)
        @artist_data        =    User.where("username = ?",artist_id).first
       # abort( @artist_data.to_json)
        @professional_experiences = ProfessionalExperience.where('user_id = ? ',  @artist_data.id)
        @education_experiences = EducationExperience.where('user_id = ? ', @artist_data.id)
        @production_experiences = ProductionExperience.where('user_id = ? ', @artist_data.id)
    end

    def user_statistics
    end

    def user_portfolio
    end

    def user_setting
        @user = User.find_by(id: current_user.id)
        @user_setting = UserSetting.find_by(user_id: current_user.id)
        if !@user_setting.present?
            @user_setting = UserSetting.new
        end
    end
    
    def update_profile
        
        @user = User.find_by(id: current_user.id)
        
        if (params[:user][:password].present? && params[:user][:confirm_password].present?)
            if (params[:user][:password] == params[:user][:confirm_password])
                if @user.update_attributes(user_params)
                    # Sign in the user by passing validation in case their password changed
                    sign_in @user, :bypass => true
                    flash[:notice] = "Password changed successfully."
                    redirect_to user_setting_path
                end
            else
                flash[:error] = "Password and Confirm password are different."
                redirect_to user_setting_path 
            end
        elsif(!params[:user][:password].present?)
            flash[:error] = "Password field can't be blank."
            redirect_to user_setting_path
        elsif(!params[:user][:confirm_password].present?)
            flash[:error] = "Confirm Password field can't be blank."
            redirect_to user_setting_path  
        end 
    end

    def update_userprofile
        @user = User.find_by(id: current_user.id)
        
        if (params[:user][:email].present?)
            
                if @user.update_attributes(user_params)
                    # Sign in the user by passing validation in case their password changed
                    flash[:notice] = "Profile Data changed successfully."
                    redirect_to user_setting_path
                end
        else
            flash[:error] = "Profile Fields can't be blank."
            redirect_to user_setting_path
        end 
    end
    def update_username
        @user = User.find_by(id: current_user.id)
        
        if (params[:user][:username].present?)
            
                if @user.update_attributes(user_params)
                    # Sign in the user by passing validation in case their password changed
                    flash[:notice] = "Username changed successfully."
                    redirect_to user_setting_path
                end
        else
            flash[:error] = "Username can't be blank."
            redirect_to user_setting_path
        end 
    end

    def blocked_users
        @blockuserdata = BlockUser.find_by(user_id: current_user.id)

        if params[:user][:username].present?
            if !@blockuserdata.present?
                BlockUser.create(user_id: current_user.id, block_user_id: params[:user][:username])
                flash[:notice] = "Users successfully blocked."
                redirect_to user_setting_path
            elsif @blockuserdata.present?
                BlockUser.where(id: @blockuserdata.id).update_all(user_id: current_user.id, block_user_id: params[:user][:username])
               
                flash[:notice] = "Users successfully blocked."
                redirect_to user_setting_path
            end
                
        else
            flash[:error] = "Please select users to block."
            redirect_to user_setting_path
        end
    end
    def notification_setting
        #abort(params[:emailnotify_like_myartwork].to_json)
        @usersettingdata = UserSetting.find_by(user_id: current_user.id)
        if !@usersettingdata.present?
            UserSetting.create(user_id: current_user.id, emailnotify_like_myartwork: params[:emailnotify_like_myartwork], emailnotify_comment_myartwork: params[:emailnotify_comment_myartwork], emailnotify_followme: params[:emailnotify_followme], emailnotify_like_mycomment: params[:emailnotify_like_mycomment], emailnotify_following_user_newartwork: params[:emailnotify_following_user_newartwork], emailnotify_comment_on_mycommentedpost: params[:emailnotify_comment_on_mycommentedpost], emailnotify_reply_on_mycomment: params[:emailnotify_reply_on_mycomment], emailnotify_subcribed_challengesubmission: params[:emailnotify_subcribed_challengesubmission], emailnotify_like_mysubmission: params[:emailnotify_like_mysubmission], emailnotify_like_mysubmissionupdate: params[:emailnotify_like_mysubmissionupdate], emailnotify_challenge_announcements: params[:emailnotify_challenge_announcements], emailnotify_newreply_on_challengeannouncement: params[:emailnotify_newreply_on_challengeannouncement], emailnotify_newreply_on_challengesubmissionupdate: params[:emailnotify_newreply_on_challengesubmissionupdate], emailnotify_like_repliestodiscussion: params[:emailnotify_like_repliestodiscussion], emailnotify_like_postedchallengeannouncement: params[:emailnotify_like_postedchallengeannouncement], notifyme_like_myartwork: params[:notifyme_like_myartwork], notifyme_comment_myartwork: params[:notifyme_comment_myartwork], notifyme_followme: params[:notifyme_followme], notifyme_like_mycomment: params[:notifyme_like_mycomment], notifyme_following_user_newartwork: params[:notifyme_following_user_newartwork], notifyme_comment_on_mycommentedpost: params[:notifyme_comment_on_mycommentedpost], notifyme_reply_on_mycomment: params[:notifyme_reply_on_mycomment], notifyme_subcribed_challengesubmission: params[:notifyme_subcribed_challengesubmission], notifyme_like_mysubmission: params[:notifyme_like_mysubmission], notifyme_like_mysubmissionupdate: params[:notifyme_like_mysubmissionupdate], notifyme_challenge_announcements: params[:notifyme_challenge_announcements], notifyme_newreply_on_challengeannouncement: params[:notifyme_newreply_on_challengeannouncement], notifyme_newreply_on_challengesubmissionupdate: params[:notifyme_newreply_on_challengesubmissionupdate], notifyme_like_repliestodiscussion: params[:notifyme_like_repliestodiscussion], notifyme_like_postedchallengeannouncement: params[:notifyme_like_postedchallengeannouncement], emailnotify_announcement_subscription: params[:emailnotify_announcement_subscription], emailnotify_newjob_jobdigest_subscription: params[:emailnotify_newjob_jobdigest_subscription], emailnotify_newtutorials_jobdigest_subscription: params[:emailnotify_newtutorials_jobdigest_subscription], emailnotify_newdownloads_jobdigest_subscription: params[:emailnotify_newdownloads_jobdigest_subscription])
            flash[:notice] = "Notification Setting Saved."
            redirect_to user_setting_path
        elsif @usersettingdata.present?
            UserSetting.where(id: @usersettingdata.id).update_all(user_id: current_user.id, emailnotify_like_myartwork: params[:emailnotify_like_myartwork], emailnotify_comment_myartwork: params[:emailnotify_comment_myartwork], emailnotify_followme: params[:emailnotify_followme], emailnotify_like_mycomment: params[:emailnotify_like_mycomment], emailnotify_following_user_newartwork: params[:emailnotify_following_user_newartwork], emailnotify_comment_on_mycommentedpost: params[:emailnotify_comment_on_mycommentedpost], emailnotify_reply_on_mycomment: params[:emailnotify_reply_on_mycomment], emailnotify_subcribed_challengesubmission: params[:emailnotify_subcribed_challengesubmission], emailnotify_like_mysubmission: params[:emailnotify_like_mysubmission], emailnotify_like_mysubmissionupdate: params[:emailnotify_like_mysubmissionupdate], emailnotify_challenge_announcements: params[:emailnotify_challenge_announcements], emailnotify_newreply_on_challengeannouncement: params[:emailnotify_newreply_on_challengeannouncement], emailnotify_newreply_on_challengesubmissionupdate: params[:emailnotify_newreply_on_challengesubmissionupdate], emailnotify_like_repliestodiscussion: params[:emailnotify_like_repliestodiscussion], emailnotify_like_postedchallengeannouncement: params[:emailnotify_like_postedchallengeannouncement], notifyme_like_myartwork: params[:notifyme_like_myartwork], notifyme_comment_myartwork: params[:notifyme_comment_myartwork], notifyme_followme: params[:notifyme_followme], notifyme_like_mycomment: params[:notifyme_like_mycomment], notifyme_following_user_newartwork: params[:notifyme_following_user_newartwork], notifyme_comment_on_mycommentedpost: params[:notifyme_comment_on_mycommentedpost], notifyme_reply_on_mycomment: params[:notifyme_reply_on_mycomment], notifyme_subcribed_challengesubmission: params[:notifyme_subcribed_challengesubmission], notifyme_like_mysubmission: params[:notifyme_like_mysubmission], notifyme_like_mysubmissionupdate: params[:notifyme_like_mysubmissionupdate], notifyme_challenge_announcements: params[:notifyme_challenge_announcements], notifyme_newreply_on_challengeannouncement: params[:notifyme_newreply_on_challengeannouncement], notifyme_newreply_on_challengesubmissionupdate: params[:notifyme_newreply_on_challengesubmissionupdate], notifyme_like_repliestodiscussion: params[:notifyme_like_repliestodiscussion], notifyme_like_postedchallengeannouncement: params[:notifyme_like_postedchallengeannouncement], emailnotify_announcement_subscription: params[:emailnotify_announcement_subscription], emailnotify_newjob_jobdigest_subscription: params[:emailnotify_newjob_jobdigest_subscription], emailnotify_newtutorials_jobdigest_subscription: params[:emailnotify_newtutorials_jobdigest_subscription], emailnotify_newdownloads_jobdigest_subscription: params[:emailnotify_newdownloads_jobdigest_subscription])
           
            flash[:notice] = "Notification Setting Updated."
            redirect_to user_setting_path
        end
    end

    def unfollow_artist
        artist_id = params[:artist_id]
        user_id   = current_user.id
        Follow.where(user_id: user_id, artist_id: artist_id).delete_all
        render json: {'res' => 1, 'message' => 'Successfully unfollowed.'}, status: 200
    end

     def unfollow_user

        user_id         = params[:user_id]
        artist_id       = current_user.id
        Follow.where(user_id: user_id, artist_id: artist_id).delete_all
        render json: {'res' => 1, 'message' => 'Successfully unfollowed.'}, status: 200
    end

    def get_artist_like(artist_id)
            user_like_me             = PostLike.where('artist_id = ?', artist_id).count
            user_follow_me           = Follow.where('artist_id = ?', artist_id).count
            res                      =  {'user_like_me':user_like_me, 'user_follow_me':user_follow_me} 
            return res
    end


     def search_all_artists

       
       conditions = "profile_type='Artist' AND is_deleted = 0 AND confirmed_at IS NOT NULL"
         
        if(params[:firstname] && params[:firstname] != '')
          conditions += " AND firstname LIKE '%"+ params[:firstname] +"%'"
        end 

         order = 'DESC'
         if params[:order].present?
            order = 'ASC'
         end   

        result    = User.where(conditions).order('id '+order)

        final_data = []
         result.each_with_index do |data, index| 
           # abort(data.id.to_json)
            res     =   get_artist_like(data.id)
            final_data[index]  = {'data': data,'country_name': data.country,'like_res': res}
         end
         #abort(final_data.to_json)
        render :json => final_data.to_json, status: 200 



    end  



    def browse_all_companies
    end

    def get_artist_list

        orderby = 'DESC'
        if(params[:order] && params[:order] != '') 
                orderby = params[:order]
        end
    #  abort(params.to_json)

        conditions = "is_deleted = 0 AND confirmed_at IS NOT NULL "

        if(params[:profile_type] && params[:profile_type] != '') 
            conditions += " AND profile_type= '"+ params[:profile_type] +"'"
        end

        if(params[:country_id] && params[:country_id] != '') 
            conditions += " AND country_id= '"+ params[:country_id] +"'"
        end

        if(params[:full_time_employment] && params[:full_time_employment] != '') 
            conditions += " AND full_time_employment= '"+ params[:full_time_employment] +"'"
        end

        if(params[:contract] && params[:contract] != '') 
            conditions += " AND contract= '"+ params[:contract] +"'"
        end

        if(params[:freelance] && params[:freelance] != '') 
            conditions += " AND freelance= '"+ params[:freelance] +"'"
        end


        if (params[:browse_by] && (params[:browse_by] == 'popular' || params[:browse_by] == 'top'))

             if params[:browse_by] == 'popular'
                  
                  result    = User.where(conditions).order('view_count DESC, id DESC')
              
              elsif params[:browse_by] == 'top'
                    
                  result    = User.where(conditions).order('like_count DESC, id DESC')
              end 
        else  

          @users      = User.where(conditions).order('id '+ orderby)
        end

        render :json => @users.to_json(:include => [:country]), status: 200

    end 


    def artist_profile

        artist_id         =   params[:id]
        @artist_data      =   User.where("username = ?",artist_id).first

 
    end    

     def save_view_count
#abort(params.to_json)
       if params[:user_id].present?
            user_id         = params[:user_id]
            record          = User.where("id = ?",user_id).first

            prevoius_view_count   =  record.view_count
            newview_count         =  prevoius_view_count + 1
            
            record.update(view_count: newview_count) 
       end     
       render :json => {'message': 'success'}, status: 200 
    end   


    private
        def user_params
            params.require(:user).permit(:email, :password, :username, {:block_user_id => [:username]}, :password_confirmation, :current_password, :firstname, :lastname, :professional_headline, :phone_number, :profile_type, :country_id, :city, :image, :summary, :demo_reel, {:skill_expertise => []}, {:software_expertise => []}, :public_email_address, :website_url, :facebook_url, :linkedin_profile_url, :twitter_handle, :instagram_username, :behance_username, :tumbler_url, :pinterest_url, :youtube_url, :vimeo_url, :google_plus_url, :stream_profile_url, :show_message_button, :full_time_employment, :contract, :freelance, :available_from, :professional_experiences_attributes => [:id,:company_id,:company_name,:title, :location, :from_month, :from_year, :to_month, :to_year, :currently_worked, :description, :professionalexperienceable_id, :professionalexperienceable_type, :_destroy, :tmp_professionalexperience, :professionalexperience_cache, :user_id])
        end
       

        def find_associated_data
            @professional_experiences = ProfessionalExperience.where('user_id = ?', current_user)
            @production_experiences   = ProductionExperience.where('user_id = ?', current_user)
            @education_experiences    = EducationExperience.where('user_id = ?', current_user)
           # @follower                 = Follow.where('artist_id = ?', current_user)
           # @following                = Follow.where('user_id = ?', current_user)
           # @like                     = PostLike.where('user_id = ?', current_user.id)
        end
  
end
