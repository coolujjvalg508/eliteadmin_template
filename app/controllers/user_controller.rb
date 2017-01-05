class UserController < ApplicationController

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

        
        params[:user] ||= {'submit'=> true}
        if params[:user] == {'submit'=> true}
            flash[:error] = "Image can't be blank."
        end
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

    def join_challenge
    end

    def user_followers
    end

    def user_following
    end

    def user_like
    end

    def user_profile_info
    end

    def user_statistics
    end

    def user_portfolio
    end

    def user_setting
    end

    private
        def user_params
            params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :firstname, :lastname, :professional_headline, :phone_number, :profile_type, :country_id, :city, :image, :summary, :demo_reel, :skill_expertise, :software_expertise, :public_email_address, :website_url, :facebook_url, :linkedin_profile_url, :twitter_handle, :instagram_username, :behance_username, :tumbler_url, :pinterest_url, :youtube_url, :vimeo_url, :google_plus_url, :stream_profile_url, :show_message_button, :full_time_employment, :contract, :freelance, :available_from)
        end
  
end
