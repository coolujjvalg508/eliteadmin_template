class ApplicationController < ActionController::Base
  helper Bootsy::Engine.helpers
  protect_from_forgery with: :exception
  #before_action :check_admin, if: -> { controller_path =~ /admin/ && controller_name != sessions && controller_name != passwords}
 
 def after_sign_in_path_for (resource)
		if resource.is_a?(AdminUser)
			admin_root_path
		else
			stored_location_for(resource) || root_path
		end
	end
  
	private
		def check_admin
			unless current_admin_user.present?
				redirect_to new_admin_user_session_path
			end
		end
  
end
