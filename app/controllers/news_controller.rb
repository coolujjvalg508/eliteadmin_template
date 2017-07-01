class NewsController < ApplicationController
	include AdsForPages
	before_action :authenticate_user!, only: [:new, :create, :edit, :update, :save_news_rating, :listing_index]
  before_filter :set_data, only: [:new, :create, :update, :edit]

	def index
      @categories = NewsCategory.where('parent_id IS NULL').order('name ASC')
      @subcategories = NewsCategory.where('parent_id IS NOT NULL').order('name ASC')

  end

	def show
		@paramlink = params[:paramlink]
    @news_data = News.where('paramlink = ?', @paramlink).first

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
		# get all ads and set the instance variables to display in view
		get_ads("news")
	end

  def listing_index

  end

    def get_all_category_list

        conditions = "true "
        if(params[:parent_id] && params[:parent_id] != '' && params[:parent_id] != 'all')
          conditions += " AND parent_id=" + params[:parent_id]
        else
          conditions += " AND parent_id IS NULL "
        end

        result   = NewsCategory.where(conditions).order('name ASC')

        sub_category_data = []

        result.each_with_index do |d, k|

          result1 = NewsCategory.where('parent_id = ?', d.id).order('name ASC')

          data = Hash.new

          data[:category] = d
          data[:sub_category] = result1
          sub_category_data.push data

        end

        render json: {'category_data': sub_category_data}, status: 200

    end

    def get_category_detail
        slug =  params[:category]
          category_data       =   NewsCategory.where('slug = ?', slug).first
          sub_category_list   =   NewsCategory.where('parent_id = ?', category_data.id).select("news_categories.*, (SELECT COUNT(*) FROM news WHERE sub_category_id::jsonb ?| array[cast(news_categories.id as text)] AND status=1 AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))) AS count_news").order('name ASC')
          #abort(sub_category_result.to_json)
           tags_list = Tag.where('tagable_id = ? AND tagable_type = ?' , category_data.id, 'News')
        render json: {'category_data': category_data, 'sub_category_list': sub_category_list, 'tags_list': tags_list}, status: 200
    end

    def get_category_news_list

          news_data = []

          if ((params[:category_id].present? && !params[:category_id].nil?) || (params[:sub_category_id].present? && !params[:sub_category_id].nil?))

            conditions = "true "

            if params[:category_id].present? && !params[:category_id].nil?
              category_id     =  params[:category_id]
              conditions      +=  " AND category_id::jsonb ?| array['" + category_id.to_s + "'] "
            end

            if params[:sub_category_id].present? && !params[:sub_category_id].nil?
              sub_category_id =  params[:sub_category_id]
              conditions      +=  " AND sub_category_id::jsonb ?| array['" + sub_category_id.to_s + "'] "
            end

           order_by = 'id DESC'
            if params[:order_by].present? && params[:order_by].downcase == 'asc'
              order_by = 'id ASC'
            end

            news_result   =  News.where(conditions).order(order_by)

            news_data   = JSON.parse(news_result.to_json(:include => [:user]))

          end

            render json: {'news_data': news_data}, status: 200

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

    def count_user_news_post

        conditions = "user_id=#{current_user.id} AND is_admin != 'Y'"

        r_data = News.where(conditions)

        total_count = r_data.count
        total_trash = total_featured = total_published = total_draft = 0

        r_data.each do |val|

          if val['is_featured'] == 1
                if val['is_trash'] == 0
                    total_featured = total_featured + 1
                end
          end

          if val['publish'] == 1
              if val['is_trash'] == 0
                 total_published = total_published + 1

              end
          end

          if val['is_save_to_draft'] == 1
               if val['is_trash'] == 0
                    total_draft = total_draft + 1
               end
          end

          if val['is_trash'] == 1
                   total_trash = total_trash + 1
          end

        end

        result = {'total_count' => total_count, 'total_featured' => total_featured, 'total_published' => total_published, 'total_draft' => total_draft, 'total_trash'=> total_trash}

        render json: result, status: 200

        #abort(result.to_json)
    end

    def get_usernews_list

        conditions = "user_id=#{current_user.id} AND is_admin != 'Y'"

        # if(params[:post_type] && params[:post_type] != '')
        #     conditions += " AND post_type_id::jsonb ?| array['" + params[:post_type] + "'] "
        # end

        # if(params[:job_category] && params[:job_category] != '')
        #    conditions += " AND job_category::jsonb ?| array['" + params[:job_category] + "'] "
        # end



        if(params[:view])
          if (params[:view] == 'featured')
            conditions += ' AND is_featured=1  AND is_trash = 0'
          elsif (params[:view] == 'published')
            conditions += ' AND publish=1  AND is_trash = 0'
          elsif (params[:view] == 'drafts')
            conditions += ' AND is_save_to_draft=1  AND is_trash = 0'
          elsif (params[:view] == 'trash')
            conditions += ' AND is_trash=1'
          end
        end


       #abort(conditions.to_json)
        result = News.where(conditions).order('id DESC')
        #abort(result.to_json)
        render :json => result.to_json, status: 200

    end


  def make_trash
         #abort(params.to_json)
         paramlink             =  params[:paramlink]
         @is_exist     =  News.where(paramlink: paramlink).first
        # abort(@is_gallery_exist.to_json)
         if @is_exist.present?
            News.where('id = ?',@is_exist.id).update_all(:is_trash => 1)
            flash[:notice] = 'News has successfully trashed.'
            redirect_to index_news_path
         end

  end

  def delete_from_trash

       paramlink  =  params[:paramlink]
       @is_exist  =  News.where(paramlink: paramlink).first
       if @is_exist.present?
          News.where('id = ?',@is_exist.id).delete_all
          flash[:notice] = 'News has successfully deleted.'
          redirect_to index_news_path
       end
  end

  def restore_news

     paramlink                  =  params[:paramlink]
     @is_news_exist         =  News.where(paramlink: paramlink).first

     if @is_news_exist.present?
        News.where('id = ?',@is_news_exist.id).update_all(:is_trash => 0)
        flash[:notice] = 'News has successfully restored.'
        redirect_to index_news_path
     end
  end

  def delete_news_post
    id                   =  params[:news_id]
    viewtype             =  params[:viewtype]
    if id.present?
      id.each do |id|

        if viewtype != "trash"
          @is_news_exist     =  News.where(id: id).first
          if @is_news_exist.present?
              News.where(id: id).update_all(:is_trash => 1)
              flash[:notice] = 'News has successfully trashed.'
          end
        else
          @is_news_exist     =  News.where(id: id).first
          if @is_news_exist.present?
              News.where(id: id).delete_all
              flash[:notice] = 'News has successfully deleted.'
          end
        end
      end
      render :json => {'res' => 1, 'message' => 'News has successfully trashed'}, status: 200
    end
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

  def news_sub_category

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
		    condition_inner = "category_id::jsonb ?| array['" + d.id.to_s + "'] AND is_approved = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone)) "

		    if(params[:is_featured] && params[:is_featured] != '' && params[:is_featured] != 'all')
	         	condition_inner += " AND is_featured=" + params[:is_featured]
	      	end

	      	if(params[:category_id] && params[:category_id] != '' && params[:category_id] != 'all')
				condition_inner += " AND category_id::jsonb ?| array['" + params[:category_id] + "'] "
			end

			if(params[:sub_category_id] && params[:sub_category_id] != '' && params[:sub_category_id] != 'all')
				condition_inner += " AND sub_category_id::jsonb ?| array['" + params[:sub_category_id] + "'] "
			end
			# For sorting news data when user vists from Features section on Home page
			cols_for_order = 'id DESC'
			if params[:sort]
				case params[:sort]
				when "top"
					cols_for_order = 'view_count DESC, id DESC'
				end
			end
			# condition for ordering data ends here

			news_data = News.where(condition_inner).order(cols_for_order).limit(4)

			#abort(news_data.to_json)

			news = JSON.parse(news_data.to_json(:include => [:images, :user]))

			if news_data.present?
				final_data[i] = {'Category' => d, 'News' => news}
				i = i + 1
			end

	    end

	    #abort(final_data.to_json)
	    render json: final_data, status: 200

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

  def new
      @news = News.new
  end

  def edit
      @news = News.find_by(paramlink: params[:paramlink])
      render 'new'
  end

  def create

        title = params['news']['title']
        slugVal = create_slug(title)

        final_slug = check_slug_available(slugVal, slugVal, 0, news_id = 0)

        params['news']['paramlink'] = final_slug
        params['news']['user_id']   = current_user.id.to_s
        params['news']['is_admin']  = 'N'

        if params['commit'] == 'Publish'
            params['news']['is_save_to_draft'] = 0

        elsif params['commit'] == 'SaveDraft'
            params['news']['is_save_to_draft'] = 1
        end

        params['news']['is_featured'] = false
        params['news']['is_urgent'] = false
        if params['news']['package_id'].nil?
          params['news']['is_approved'] = true
        else
          params['news']['is_approved'] = false

          if params['news']['package_id'].include?('1')
            params['news']['is_featured'] = true
          end

          if params['news']['package_id'].include?('2')
            params['news']['is_urgent'] = true
          end

        end

        @news = News.new(news_params)

        if @news.save

            tags_list = params['news']['tag']['tag']
            tags_list.reject!{|a| a==""}

            tags_list.each do |tag_val|

                Tag.create(
                    tag: tag_val,
                    tagable_id: @news['id'],
                    tagable_type: 'News'
                )

            end

            ############################################

            if params[:news][:crop_x].present?
                @news.company_logo = @news.company_logo.resize_and_crop
                @news.save!
                @news.company_logo.recreate_versions!
            end
            ############################################

            if params[:news][:avatar].present?
                 caption_image  = params[:news][:avatar_caption]
                  my_array = params[:news][:removedids].split(',')
                 #abort(my_array.inspect)
                 params[:news][:avatar].each.with_index do |a,index|
                   caption = ''
                   if  !caption_image.nil? && caption_image[index].present?
                        caption = caption_image[index]['caption_image']
                   end
                    if !my_array.include?(index.to_s)
                         @image = @news.images.create!(:image => a[:image],:caption_image => caption)
                    end

                 end
            end

            ################ Store news content data and its media content start #############
            if params[:news_content].present?

              params[:news_content].each_with_index do |news_content_data, k|

                media_content = news_content_data[1][:media_contents_attributes]
                @news_content = NewsContent.create(title: news_content_data[1][:title], news_id: @news['id'])

                if !@news_content['id'].nil?
                  media_content.each_with_index do |media_data, k1|
                    MediaContent.create(mediacontent: media_data[1][:mediacontent], mediacontentable_id: @news_content['id'], mediacontentable_type: 'NewsContent', media_type: media_data[1][:media_type], media_description: media_data[1][:media_description])
                  end
                end

              end

            end
            ################ Store news content data and its media content end #############

            redirect_to index_news_path, notice: 'News Successfully Created.'

        else
            render 'new'
        end

  end

  def update

        @news = News.find_by(paramlink: params[:paramlink])

        title = params['news']['title']

        slugVal = create_slug(title)

        final_slug = check_slug_available(slugVal, slugVal, 0, news_id = @news.id.to_s)

        params['news']['paramlink'] = final_slug


        if params['commit'] == 'Publish'
            params['news']['is_save_to_draft'] = 0

        elsif params['commit'] == 'SaveDraft'
            params['news']['is_save_to_draft'] = 1
        end

        if @news.update(news_params)

            #to delete all previous tags
            Tag.where("tagable_id = ? AND tagable_type = 'News'", @news['id']).delete_all

            #to add new tags
            tags_list = params['news']['tag']['tag']
            tags_list.reject!{|a| a==""}
            tags_list.each do |tag_val|

               Tag.create(
                    tag: tag_val,
                    tagable_id: @news['id'],
                    tagable_type: 'News'
                )

            end

            ############################################

            if params[:news][:crop_x].present?
                @news.company_logo = @news.company_logo.resize_and_crop
                @news.save!
                @news.company_logo.recreate_versions!
            end
            ############################################

            if params[:news][:avatar].present?
                 caption_image  = params[:news][:avatar_caption]
                 my_array = params[:news][:removedids].split(',')

                 params[:news][:avatar].each.with_index do |a,index|
                   caption = ''
                   if caption_image[index].present?
                        caption = caption_image[index]['caption_image']
                   end

                    if !my_array.include?(index.to_s)
                         @image = @news.images.create!(:image => a[:image],:caption_image => caption)
                    end

                 end
            end

            ################ Store news content data and its media content start #############
            if params[:news_content].present?

              params[:news_content].each_with_index do |news_content_data, k|

                media_content = news_content_data[1][:media_contents_attributes]
                @news_content = NewsContent.create(title: news_content_data[1][:title], news_id: @news['id'])

                if !@news_content['id'].nil?
                  media_content.each_with_index do |media_data, k1|
                    MediaContent.create(mediacontent: media_data[1][:mediacontent], mediacontentable_id: @news_content['id'], mediacontentable_type: 'NewsContent', media_type: media_data[1][:media_type], media_description: media_data[1][:media_description])
                  end
                end

              end

            end
            ################ Store news content data and its media content end #############

            ######## to delete news content start ###########
            if params['news']['removedNewsContent'].present?
              removed_news_content_array = params[:news][:removedNewsContent].split(',')
              if removed_news_content_array.present?
                NewsContent.where("id IN (?)", removed_news_content_array).delete_all
              end
            end
            ######## to delete news content end ############

            ######## to delete MediaContent start ###########
            if params['news']['removedMediaContent'].present?
              removed_media_content_array = params[:news][:removedMediaContent].split(',')
              if removed_media_content_array.present?
                MediaContent.where("id IN (?)", removed_media_content_array).delete_all
              end
            end
            ######## to delete MediaContent end ############

            ################ Store news content data and its media content start #############
            if params[:news_content_default].present?

              params[:news_content_default].each_with_index do |news_content_data, k|

                @news_content_update = NewsContent.find_by(id: news_content_data[0])
                @news_content_update.update(title: news_content_data[1][:title])

                media_content = news_content_data[1][:media_contents_attributes]

                if !media_content.nil?
                  media_content.each_with_index do |media_data, k1|

                    if media_data[1][:id] == ''

                      MediaContent.create(mediacontent: media_data[1][:mediacontent], mediacontentable_id: news_content_data[0], mediacontentable_type: 'NewsContent', media_type: media_data[1][:media_type], media_description: media_data[1][:media_description])

                    else

                      @media_content_update = MediaContent.find_by(id: media_data[1][:id])

                      @media_content_update.update(mediacontent: media_data[1][:mediacontent], media_type: media_data[1][:media_type], media_description: media_data[1][:media_description])
                    end

                  end
                end

              end

            end
            ################ Store news content data and its media content end #############

            redirect_to index_news_path, notice: 'News Successfully Updated.'

        else
            render 'new'
        end
  end

  def get_news_category_list

    conditions = "true "
    if(params[:parent_id] && params[:parent_id] != '' && params[:parent_id] != 'all')

      if params[:parent_id].kind_of?(Array)
        conditions += " AND parent_id IN (" + params[:parent_id].map(&:inspect).join(',').gsub('"','') + ")"
      else
        conditions += " AND parent_id=" + params[:parent_id]
      end

    else
        conditions += " AND parent_id IS NULL "
    end

    result = NewsCategory.where(conditions).order('name ASC')
    render json: result, status: 200
  end


  def save_view_count

       if params[:news_id].present?
            news_id      = params[:news_id]
            record          = News.where("id = ?",news_id).first

            prevoius_view_count   = record.view_count
            newview_count         =  prevoius_view_count + 1

            result = record.update(view_count: newview_count)
       end
       render json: result, status: 200
    end

  private
    def news_params
          params.require(:news).permit(:title, :is_featured, :is_urgent, :is_approved, :use_tag_from_previous_upload, :has_adult_content, :user_id, :is_admin, :paramlink, :show_on_cgmeetup, :show_on_website, :schedule_time, {:category_id => []}, {:sub_category_id => []}, {:software_used => []}, {:package_id => []}, :tags, :status, :is_save_to_draft, :visibility, :publish, :company_logo, :tags_attributes => [:id, :tag, :tagable_id, :tagable_type, :_destroy, :tmp_tag, :tag_cache])
    end

    def check_slug_available(slugVal, newSlugVal, i, news_id)

        result = News.where('id != ? AND paramlink = ?', news_id, newSlugVal).count

        if result == 0
            return newSlugVal
        else
            i = i + 1
            newSlugVal = slugVal + '-' + i.to_s
            check_slug_available(slugVal, newSlugVal, i, news_id)
        end

    end

    def set_data
      @category = NewsCategory.where('parent_id IS NULL').order('name ASC')
      @software_expertise = SoftwareExpertise.where("parent_id IS NULL").order('name ASC').pluck(:name, :id)
      @package     =  NewsPackage.all
    end

end
