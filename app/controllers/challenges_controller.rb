class ChallengesController < ApplicationController

    before_action :authenticate_user!, only: [:index,:get_challenge_list,:join_challenge,:dashboard]
 
    def index

    end   

    def show
    	#abort(params.to_json)
    	challenge_id    = params[:id]	
    	@challenge_data = Challenge.where("id = ?",challenge_id).first

      if @challenge_data.present?
          @countres       = get_challengers_count(@challenge_data.id);
      else
          @countres       =   0
      end 
          
    end	


  def get_challenge_list

      conditions = "visibility = 0 AND status = 1 AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone)) "

      if(params[:challenge_type_id] && params[:challenge_type_id] != '' && params[:challenge_type_id] != 'all') 
         conditions += " AND challenge_type_id=" + params[:challenge_type_id]
      end

      challenge_data = Challenge.where(conditions).order('id DESC')
      
      #result     = JSON.parse(challenge_data.to_json(:include => [:user]))

    # abort(result.to_json)

      final_data = []
      challenge_data.each_with_index do |data, index| 
          res_count  = get_challengers_count(data.id)
          final_data[index]  = {'result': data,'challenger_count': res_count}
             
      end
      
     #abort(final_data.to_json)

      render json: final_data, status: 200  
    
    
  end

  def get_challengers_count(value)
          result       = Contest.where("challenge::jsonb ?| array['" + value.to_s + "']").count
          
  end  

end
