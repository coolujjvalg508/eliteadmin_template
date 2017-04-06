class ChallengesController < ApplicationController

    before_action :authenticate_user!, only: [:index,:get_challenge_list]
 
    def index

    end   

    def show
    	#abort(params.to_json)
    	@challenge_id    = params[:id]	
    	@challenge_data = Challenge.where("id = ?",@challenge_id).first

      if @challenge_data.present?
          @countres       = get_challengers_count(@challenge_data.id);
      else
          @countres       =   0
      end 
          
    end	

    def save_view_count
          if params[:challenge_id].present?
              challenge_id          = params[:challenge_id]
              record                = Challenge.where("id = ?",challenge_id).first

              prevoius_view_count   = record.view_count
              newview_count         =  prevoius_view_count + 1
              
              record.update(view_count: newview_count) 
          end     
          render json: {'res' => 0, 'message' => 'success'}, status: 200       
    end 


  def get_challenge_list

      conditions = "visibility = 0 AND status = 1 AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone)) "

      if(params[:challenge_type_id] && params[:challenge_type_id] != '' && params[:challenge_type_id] != 'all') 
         conditions += " AND challenge_type_id=" + params[:challenge_type_id]
      end


     if (params[:browse_by] && (params[:browse_by] == 'popular' || params[:browse_by] == 'top'))
          
            if params[:browse_by] == 'popular'
                 challenge_data    = Challenge.where(conditions).order('view_count DESC, id DESC')
             elsif params[:browse_by] == 'top'
                 challenge_data    = Challenge.where(conditions).order('id DESC')
            end             
      else  
             challenge_data        = Challenge.where(conditions).order('id DESC')
      end

      
      
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
