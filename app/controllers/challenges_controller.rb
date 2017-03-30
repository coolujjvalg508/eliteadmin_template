class ChallengesController < ApplicationController

    before_action :authenticate_user!, only: [:index,:get_challenge_list,:join_challenge]
 
    def index

    end   

    def show
    	#abort(params.to_json)
    	challenge_id    = params[:id]	
    	@challenge_data = Challenge.where("id = ?",challenge_id).first

    end	


    def join_challenge
    	#abort(params.to_json)
    end


  def get_challenge_list

  	    gallerydata			=	Gallery.where("user_id = ? AND is_admin = ? AND is_trash=?",current_user.id,'N',0).pluck(:challenge)	
        challengearray		=	""
      	if gallerydata.present?
	      	gallerydata.each_with_index do |value, index|	
		    	value  = value.reject!{|a| a==""}	
		      	if value != ""	|| value != "null"
		      		value.each_with_index do |value1, index1|
		      			if value1 != "" || value1 != "null"
		      					challengearray	+=	value1
		      			end		
		      		end	
		      	end	
			end	
		end	


      conditions = "is_submitted = 0 AND visibility = 0 AND status = 1 AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone)) "

      if(params[:challenge_type_id] && params[:challenge_type_id] != '' && params[:challenge_type_id] != 'all') 
         conditions += " AND challenge_type_id=" + params[:challenge_type_id]
      end

      if challengearray.present?
			conditions += " AND id IN (#{challengearray})"
      end	

     #abort(conditions.to_json)
      challenge_data = Challenge.where(conditions).order('id DESC')
	#abort(challenge_data.to_json)
      final_data = JSON.parse(challenge_data.to_json(:include => [:user]))

      render json: final_data, status: 200  

    
  end



end
