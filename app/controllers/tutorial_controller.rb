class TutorialController < ApplicationController
	def index
		@topics = Topic.where('parent_id IS NULL').order('name ASC')
	end

	def tutorial_post

	end	

	def tutorial_category

		@topic_id = params[:id]

		@topic_details = Topic.find_by(id: @topic_id);

		@sub_topics = Topic.where('parent_id = ?', @topic_id).select("topics.*, (SELECT COUNT(*) FROM tutorials WHERE sub_topic::jsonb ?| array[cast(topics.id as text)]) AS count_tutorials")

		#abort(@topic_details.to_json)

	end	

	def tutorial_all_category

	end	


	def get_tutorial_list

	    conditions = "true "

	    if(params[:topic_id] && params[:topic_id] != '' && params[:topic_id] != 'all') 
	      conditions += " AND id=" + params[:topic_id]
	    end

	    topics = Topic.where(conditions).order('name ASC')

	    #abort(topics[0].to_json)

	    final_data = []

	    i = 0
	    topics.each_with_index do |d, k|

		    condition_inner = "topic::jsonb ?| array['" + d.id.to_s + "'] AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone)) "

		    if(params[:is_featured] && params[:is_featured] != '' && params[:is_featured] != 'all') 
	         	condition_inner += " AND is_featured=" + params[:is_featured]
	      	end
		    
		    if(params[:skill_level] && params[:skill_level] != '') 
	         	condition_inner += " AND skill_level='" + params[:skill_level] + "'"
	      	end
		      
	      	if(params[:topic] && params[:topic] != '' && params[:topic] != 'all') 
				condition_inner += " AND topic::jsonb ?| array['" + params[:topic] + "'] "
			end
		      
			if(params[:sub_topic] && params[:sub_topic] != '' && params[:sub_topic] != 'all') 
				condition_inner += " AND sub_topic::jsonb ?| array['" + params[:sub_topic] + "'] "
			end

			tutorial_data = Tutorial.where(condition_inner).order('id DESC').limit(4)

			tutorial = JSON.parse(tutorial_data.to_json(:include => [:images, :user]))

			#abort(download.to_json)

			if tutorial_data.present?
				final_data[i] = {'Topic' => d, 'Tutorial' => tutorial}
				i = i + 1
			end 

	    end  

	    #abort(final_data.to_json)
	    render json: final_data, status: 200  
	    
	end

	def get_topic_list
	    conditions = "true "

	    if(params[:parent_id] && params[:parent_id] != '' && params[:parent_id] != 'all') 
	      conditions += " AND parent_id=" + params[:parent_id]

	    end

	    result = Topic.where(conditions).order('name ASC')
	    render json: result, status: 200  
	end

end
