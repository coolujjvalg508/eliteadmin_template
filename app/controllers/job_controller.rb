class JobController < ApplicationController
  def index
  	
    authenticate_user!
  end

  def get_job_list

  	authenticate_user!

    conditions = "user_id=#{current_user.id} AND is_admin != 'Y' "

    if(params[:job_type] && params[:job_type] != '' && params[:job_type] != 'all') 
       conditions += " AND job_type='" + params[:job_type] + "'"
    end

    result = Job.where(conditions).order('id DESC')

    #abort(result.to_json)
    #result = result + result + result + result + result + result + result + result + result + result + result + result
    /result.each_with_index do |x,index| 
    	abort(x.to_json)
    end/

    render :json => result.to_json(:include => [:company, :country]), status: 200

  end

  def update_user_image

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

  	@user = current_user
  	
  	@user.remove_cover_art_image!	
  	@user.save

    flash[:notice] = "Cover art removed successfully."		
    redirect_to request.referer
	  
  end
  
  def job_post  	
  end
  
  def store
  end

  private
	def user_params
	 	params.require(:user).permit(:image, :cover_art_image)
	end


end
