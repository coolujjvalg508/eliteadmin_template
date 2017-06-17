class NewsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :edit, :update, :save_news_rating, :listing_index]
	def index

		@categories = NewsCategory.where('parent_id IS NULL').order('name ASC')	

	end	


	def show
		@paramlink = params[:paramlink]
        @news_data = News.where('paramlink = ?', @paramlink).first

       
        #abort(@download_data.to_json)
        @product_avg_rating = Rating.where('product_id = ? AND post_type = ?', @news_data.id, 'news').pluck("AVG(rating) as avg_rate")

        @collection = Collection.new
        
        @has_user_already_given_rating = 0
        @is_purchased = false
        if current_user.present?
          @has_user_already_given_rating = Rating.where('user_id = ? AND product_id=? AND post_type = ?', current_user.id, @news_data.id, 'news').count 

           purchased_product = PurchasedProduct.where('user_id = ? AND download_id = ?', current_user.id, @news_data.id).limit(1).count

           if purchased_product > 0
             @is_purchased = true
           end  
        end 
    

	end	


	def check_save_like

           news_id = params[:news_id]
          newsrecord  = News.where("id = ?",news_id).first
          is_admin = newsrecord.is_admin.to_s
       
          user_id = current_user.id
          is_like_exist = PostLike.where(user_id: user_id, post_id: news_id, post_type: 'News', is_admin: is_admin).first
          result = ''
          if is_like_exist.present?
                result  = {'res' => 1, 'message' => 'Post has already liked'}
          else
                result  = {'res' => 0, 'message' => 'Post has not liked'}
          end 
          render json: result, status: 200    
             
    end



      def save_like
          news_id    	= params[:news_id]
          artist_id     = params[:artist_id]
          user_id       = current_user.id
          
          newsrecord  	= News.where("id = ?",news_id).first
          is_admin    	= newsrecord.is_admin.to_s
          
          is_like_exist   = PostLike.where(user_id: user_id, post_id: news_id, post_type: 'News', is_admin: is_admin).first
         
          result          = ''

          activity_type = ''
          if is_like_exist.present?
                activity_type = 'disliked'
                PostLike.where(user_id: user_id, post_id: news_id, post_type: 'News', is_admin: is_admin).delete_all 
                
                Notification.where(user_id: user_id,  artist_id: artist_id,  post_id: news_id, notification_type: "like", section_type: 'News', is_admin: is_admin).delete_all
                
                newlike_count  =  (newsrecord.like_count == 0) ? 0 : newsrecord.like_count - 1
                newsrecord.update(like_count: newlike_count) 

                result  = {'res' => 0, 'message' => 'Post has disliked'}

          else
                activity_type = 'liked'
                PostLike.create(user_id: user_id, artist_id: artist_id, post_id: news_id, post_type: 'News', is_admin: is_admin)  
                
                newlike_count  =  newsrecord.like_count + 1
                newsrecord.update(like_count: newlike_count) 

                Notification.create(user_id: user_id,  artist_id: artist_id,  post_id: news_id, notification_type: "like", is_read: 0, section_type: 'News', is_admin: is_admin)
                 result  = {'res' => 1, 'message' => 'Post has liked'}

          end 

          LatestActivity.create(user_id: user_id,  artist_id: artist_id,  post_id: news_id, activity_type: activity_type, section_type: 'News', is_admin: is_admin)  
          render json: result, status: 200       
    end 


    def check_follow_artist
          artist_id        	= params[:artist_id].to_i
          news_id        	= params[:news_id]
          newsrecord     	= News.where("id = ?",news_id).first
          is_admin          = newsrecord.is_admin.to_s

          user_id            = current_user.id
          is_like_exist      = Follow.where(user_id: user_id, artist_id: artist_id, post_type: '', is_admin: is_admin).first
          result = ''
          if is_like_exist.present?
                result  = {'res' => 1, 'message' => 'Artist already followed'}
          else
                result  = {'res' => 0, 'message' => 'Artist not followed'}
          end 
        

          render json: result, status: 200       
    end


    def follow_artist
        
          artist_id          	= params[:artist_id].to_i
          news_id        		= params[:news_id]
          newsrecord     		= News.where("id = ?",news_id).first
          is_admin           	= newsrecord.is_admin.to_s

          user_id            	= current_user.id
          is_follow_exist    	= Follow.where(user_id: user_id, artist_id: artist_id, post_type: '', is_admin: is_admin).first
          result = ''
          
          if is_admin == 'N'
               userrecord          = User.where(id: artist_id).first
          else
               userrecord          = AdminUser.where(id: artist_id).first
          end    

          #abort(userrecord.to_json)

          if is_follow_exist.present?
                Follow.where(user_id: user_id, artist_id: artist_id, post_type: '', is_admin: is_admin).delete_all 
                Notification.where(user_id: user_id,  artist_id: artist_id, notification_type: "follow user", section_type: 'News', is_admin: is_admin).delete_all  
                newfollow_count  =  (userrecord.follow_count == 0) ? 0 : userrecord.follow_count - 1
                userrecord.update(follow_count: newfollow_count) 

                result  = {'res' => 0, 'message' => 'Artist Not Follow'}
          else
                Follow.create(user_id: user_id, artist_id: artist_id, post_type: '', is_admin: is_admin)
                Notification.create(user_id: user_id,  artist_id: artist_id,  post_id: "", notification_type: "follow user", is_read: 0, section_type: 'News', is_admin: is_admin)  

                newfollow_count  =  userrecord.follow_count + 1
                userrecord.update(follow_count: newfollow_count) 

                result  = {'res' => 1, 'message' => 'Artist Follow'}

          end 

        
          render json: result, status: 200    
             
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





	def save_news_rating

     product_id   =  params[:product_id]
     score        =  params[:score]
     post_type    =  params[:post_type]
     user_id      =  current_user.id
   
     Rating.create(product_id: product_id, rating: score, post_type: post_type, user_id: user_id)
     result = {'res' => 1, 'message' => 'Rating successfully created', 'ratingdata' => score}
     render json: result, status: 200 
  end  


  def get_news_avg_rating
      
      postid    =   params[:product_id]
      product_avg_rating    =  Rating.where('product_id = ? AND post_type = ?', postid, 'news').pluck("AVG(rating) as avg_rate")
      render json: {'ratingdata': product_avg_rating}, status: 200  
  end  



  def mark_spam
    news_id_for_mark_spam    = params[:id]
    newsdata  = News.where(id: news_id_for_mark_spam).first
    if newsdata.is_spam == true 
        newsdata.update(is_spam: false) 
        Report.where(user_id: current_user.id, post_id: news_id_for_mark_spam, post_type: 'News', report_issue: 'Spam').delete_all

        render :json => {'res' => 0, 'message' => 'Operation is successfully done'}, status: 200 

    else  
        
        Report.create(user_id: current_user.id, post_id: news_id_for_mark_spam, post_type: 'News', report_issue: 'Spam')
        newsdata.update(is_spam: true) 
        render :json => {'res' => 1, 'message' => 'Operation is successfully done'}, status: 200 
    end
  end  


  def check_mark_spam
    news_id_for_mark_spam    = params[:id]
    newsdata                 = News.where(id: news_id_for_mark_spam).first
    #abort(jobdata.to_json)
    if newsdata.is_spam == true 
        render :json => {'res' => 1, 'message' => 'news is spam'}, status: 200 
    else  
        render :json => {'res' => 2, 'message' => 'news is not a spam'}, status: 200 
    end   
  end 
  


end
