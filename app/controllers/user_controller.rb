class UserController < ApplicationController
    before_action :find_associated_data, only: [:edit_profile, :update]
    before_action :authenticate_user!, only: [:edit_profile, :update, :user_profile_info, :user_like, :get_user_likes,:connection_followers,:get_connection_followers, :connection_following, :get_connection_following]
 
   
    def signup

    end

    def forgotpassword
    end

    def all_activity
    end

    def dashboard
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
            final_data[index]  = {'gallery': data.gallery,'images': data.gallery.images,'videos': data.gallery.videos,'upload_videos': data.gallery.upload_videos,'marmo_sets': data.gallery.marmo_sets,'sketchfebs': data.gallery.sketchfebs}
         end
        render :json => final_data, status: 200

    end

    def user_profile_info

        @professional_experiences = ProfessionalExperience.where('user_id = ? ', current_user)
        @education_experiences = EducationExperience.where('user_id = ? ', current_user)
        @production_experiences = ProductionExperience.where('user_id = ? ', current_user)

    end

    def user_statistics
    end

    def user_portfolio
    end

    def user_setting
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
             @users      = User.select("users.*, (SELECT COUNT(*) FROM follows WHERE follows.artist_id = users.id) AS following_count, (SELECT COUNT(*) FROM post_likes WHERE post_likes.user_id = users.id) AS like_count").where(conditions).order('like_count DESC, id DESC')
        else  
          @users      = User.select("users.*, (SELECT COUNT(*) FROM follows WHERE follows.artist_id = users.id) AS following_count, (SELECT COUNT(*) FROM post_likes WHERE post_likes.user_id = users.id) AS like_count").where(conditions).order('id '+ orderby)
        end

        render :json => @users.to_json(:include => [:country]), status: 200

    end 


    private
        def user_params
            params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :firstname, :lastname, :professional_headline, :phone_number, :profile_type, :country_id, :city, :image, :summary, :demo_reel, {:skill_expertise => []}, {:software_expertise => []}, :public_email_address, :website_url, :facebook_url, :linkedin_profile_url, :twitter_handle, :instagram_username, :behance_username, :tumbler_url, :pinterest_url, :youtube_url, :vimeo_url, :google_plus_url, :stream_profile_url, :show_message_button, :full_time_employment, :contract, :freelance, :available_from, :professional_experiences_attributes => [:id,:company_id,:company_name,:title, :location, :from_month, :from_year, :to_month, :to_year, :currently_worked, :description, :professionalexperienceable_id, :professionalexperienceable_type, :_destroy, :tmp_professionalexperience, :professionalexperience_cache, :user_id])
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
