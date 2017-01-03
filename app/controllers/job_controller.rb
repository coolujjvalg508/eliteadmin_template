class JobController < ApplicationController
  def index
  	
    authenticate_user!
  end

  def job_home    

  	conditions = "visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))"
  	@result = Job.where(conditions).order('id DESC').page(params[:page]).per(10)
  	@final_result = JSON.parse(@result.to_json(:include => [:company, :country]))
  end

  def get_job_list

  	authenticate_user!

    conditions = "user_id=#{current_user.id} AND is_admin != 'Y' "

    if(params[:job_type] && params[:job_type] != '' && params[:job_type] != 'all') 
       conditions += " AND job_type='" + params[:job_type] + "'"
    end

    result = Job.where(conditions).order('id DESC')

    render :json => result.to_json(:include => [:company, :country]), status: 200

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
  
 
  def apply_job
  end 

  def job_category
  end

  def job_company_list_on_map
  end

  def job_list_on_map
  end



  private
	def user_params
	 	params.require(:user).permit(:image, :cover_art_image)
	end


end
