class NewsController < ApplicationController
	def index

		@categories = NewsCategory.where('parent_id IS NULL').order('name ASC')	

	end	

	def free_news

		@topic_list = NewsCategory.where('parent_id IS NULL').select("news_categories.*, (SELECT COUNT(*) FROM news WHERE category_id::jsonb ?| array[cast(news_categories.id as text)] AND status=1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))) AS count_news").order('name ASC')


		conditions	=	"status=1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone)) "
		
			if params[:category_id].present?
				 conditions += 	" AND category_id::jsonb ?| array['" + params[:category_id] + "'] "
				 @topic_details = NewsCategory.find_by(id: params[:category_id]);
			end	

		@result = News.where(conditions).page(params[:page]).per(10)

	end	

	def news_category

	end	

	def news_all_category
	end	

	def news_post
	end

	def get_news_list

	    conditions = "true AND parent_id IS NULL"

	    if(params[:category_id] && params[:category_id] != '' && params[:category_id] != 'all') 
	      conditions += " AND id=" + params[:category_id]
	    end

	    categories = NewsCategory.where(conditions).order('name ASC')

	    #abort(categories[0].to_json)

	    final_data = []

	    i = 0
	    categories.each_with_index do |d, k|
		    condition_inner = "category_id::jsonb ?| array['" + d.id.to_s + "'] AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone)) "

		    if(params[:is_featured] && params[:is_featured] != '' && params[:is_featured] != 'all') 
	         	condition_inner += " AND is_featured=" + params[:is_featured]
	      	end
		      
	      	if(params[:category_id] && params[:category_id] != '' && params[:category_id] != 'all') 
				condition_inner += " AND category_id::jsonb ?| array['" + params[:category_id] + "'] "
			end
		      
			if(params[:sub_category_id] && params[:sub_category_id] != '' && params[:sub_category_id] != 'all') 
				condition_inner += " AND sub_category_id::jsonb ?| array['" + params[:sub_category_id] + "'] "
			end

			news_data = News.where(condition_inner).order('id DESC').limit(4)

			#abort(news_data.to_json)

			news = JSON.parse(news_data.to_json(:include => [:images, :user]))

			#abort(download.to_json)

			if news_data.present?
				final_data[i] = {'Category' => d, 'News' => news}
				i = i + 1
			end 

	    end  

	    #abort(final_data.to_json)
	    render json: final_data, status: 200  
	    
	end

	def get_category_list
	    conditions = "true "

	    if(params[:parent_id] && params[:parent_id] != '' && params[:parent_id] != 'all') 
	      conditions += " AND parent_id=" + params[:parent_id]
	    end

	    result = NewsCategory.where(conditions).order('name ASC')
	    render json: result, status: 200  
	end

end
