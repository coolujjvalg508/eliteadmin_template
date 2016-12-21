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

    render :json => result.to_json(:include => [:company]), status: 200

  end

  
  def job_post
  end
  
  def store
  end
end
