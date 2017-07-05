class ApplicationController < ActionController::Base
  	helper Bootsy::Engine.helpers
  	protect_from_forgery with: :exception
  	
  	skip_before_filter :verify_authenticity_token, if: -> { controller_name == 'sessions' && (action_name == 'create' || action_name == 'destroy')}
  	before_action :configure_permitted_parameters, if: :devise_controller?
  	before_action :set_message, if: -> { controller_name == 'sessions' && action_name == 'new'}
  	#before_action :check_admin, if: -> { controller_path =~ /admin/ && controller_name != 'sessions' && controller_name != 'passwords'}
  	before_action :site_url,:wip_gallery

    
    before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
    def site_url
    	@setting_data_m = SiteSetting.first 
	end

  	def configure_permitted_parameters
	    if params[:user].present? &&  params[:user][:image].present?
	      	params[:user][:image_attributes] = params[:user][:image]
	    end
	    devise_parameter_sanitizer.for(:sign_up).push(:firstname, :lastname, :username, :email, :password, :captcha, :captcha_key, :profile_type)
	end

 	def after_sign_in_path_for (resource)
 		
		if resource.is_a?(AdminUser)
			admin_root_path
		else
			stored_location_for(resource) || all_activity_path
		end
	end

	def set_message
    	if params[:guest_user] == "true"
    		flash[:error] = "Please login to access this area."
    	end
  	end

  	def wip_gallery
  		@wip_gallery = Gallery.where("post_type_category_id = 3 AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(9)
  		@popular_gallery = Gallery.where("is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('like_count DESC').limit(9)
  		@subscribed_user = User.where("is_subscribed = true AND to_timestamp(subscription_end_date, 'YYYY-MM-DD hh24:mi')::timestamp without time zone >= CURRENT_TIMESTAMP::timestamp without time zone").pluck(:id)
  		
  		@pro_gallery_data = Gallery.where("is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone)) AND user_id IN (?)",@subscribed_user).order('like_count DESC').limit(9)
  		#abort(@subscribed_user.to_json)
  	end


	def ensure_signup_complete
	    # Ensure we don't go into an infinite loop
	    return if action_name == 'finish_signup'

	    # Redirect to the 'finish_signup' page if the user
	    # email hasn't been verified yet
	    if current_user && !current_user.email_verified?
	      redirect_to finish_signup_path(current_user)
	    end
	end

	private
		def check_admin
			unless current_admin_user.present?
				redirect_to new_admin_user_session_path
			end
		end

		def create_slug(value)
			return value.downcase.gsub(/[^a-z0-9]+/, '-').chomp('-')
		end

  
end
