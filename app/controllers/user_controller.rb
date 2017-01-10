class UserController < ApplicationController
    before_action :find_associated_data, only: [:edit_profile, :update]

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

    def edit_profile

        authenticate_user!
        @user = current_user

    end

    def update
        authenticate_user!
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
            redirect_to user_edit_profile_path   

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
            redirect_to user_edit_profile_path  

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
            redirect_to user_edit_profile_path                  

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

                redirect_to user_edit_profile_path
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

    def user_like
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

    private
        def user_params
            params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :firstname, :lastname, :professional_headline, :phone_number, :profile_type, :country_id, :city, :image, :summary, :demo_reel, :skill_expertise, :software_expertise, :public_email_address, :website_url, :facebook_url, :linkedin_profile_url, :twitter_handle, :instagram_username, :behance_username, :tumbler_url, :pinterest_url, :youtube_url, :vimeo_url, :google_plus_url, :stream_profile_url, :show_message_button, :full_time_employment, :contract, :freelance, :available_from, :professional_experiences_attributes => [:id,:company_id,:company_name,:title, :location, :from_month, :from_year, :to_month, :to_year, :currently_worked, :description, :professionalexperienceable_id, :professionalexperienceable_type, :_destroy, :tmp_professionalexperience, :professionalexperience_cache, :user_id])
        end

        def find_associated_data
            @professional_experiences = ProfessionalExperience.where('user_id = ?', current_user)
            @production_experiences = ProductionExperience.where('user_id = ?', current_user)
            @education_experiences = EducationExperience.where('user_id = ?', current_user)
        end
  
end
