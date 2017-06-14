class TutorialsController < ApplicationController

	before_action :authenticate_user!, only: [:new, :create, :edit, :update, :listing_index]
  before_filter :set_data, only: [:new, :create, :update, :edit]

	def index
		@topics 			= Topic.where('parent_id IS NULL').order('name ASC')
		@tutorial_skill 	= TutorialSkill.order('title ASC')
	end

	def tutorial_post

	end	

  def listing_index
      
  end

	def free_tutorial

	   @topic_list = Topic.where('parent_id IS NULL').select("topics.*, (SELECT COUNT(*) FROM tutorials WHERE topic::jsonb ?| array[cast(topics.id as text)] AND free IS TRUE AND status=1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))) AS count_tutorials").order('name ASC')


		conditions	=	"free IS TRUE AND status=1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone)) "
		
		if params[:topic_id].present?
		 	conditions 		+= 	" AND topic::jsonb ?| array['" + params[:topic_id] + "'] "
			@topic_details   = Topic.find_by(id: params[:topic_id]);
		end	

		@result = Tutorial.where(conditions).page(params[:page]).per(10)
	end	

	def tutorial_category

		@topic_id = params[:id]

		@topic_details = Topic.find_by(id: @topic_id);

		@sub_topics = Topic.where('parent_id = ?', @topic_id).select("topics.*, (SELECT COUNT(*) FROM tutorials WHERE sub_topic::jsonb ?| array[cast(topics.id as text)] AND status=1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))) AS count_tutorials")

		@result = Tutorial.where("topic::jsonb ?| array['" + @topic_id + "'] OR sub_topic::jsonb ?| array['" + @topic_id + "'] AND status=1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").page(params[:page]).per(10)



		#abort(@tutorial_list.to_json)

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

			#abort(tutorial.to_json)

			if tutorial_data.present?
				final_data[i] = {'Topic' => d, 'Tutorial' => tutorial}
				i = i + 1
			end 

	    end  

	    #abort(final_data.to_json)
	    render json: final_data, status: 200  
	    
	end

	def get_subject_list
	    conditions = "true "

	    if(params[:parent_id] && params[:parent_id] != '' && params[:parent_id] != 'all') 
	      conditions += " AND topic_id=" + params[:parent_id]

	    end

	    result = TutorialSubject.where(conditions).order('name ASC')
	    render json: result, status: 200  
	end

	def get_topic_type_list

	    conditions = "true "
	    if(params[:parent_id] && params[:parent_id] != '' && params[:parent_id] != 'all') 
	      conditions += " AND parent_id=" + params[:parent_id]
	    else
	      conditions += " AND parent_id IS NULL "
	    end

	    result = Topic.where(conditions).order('name ASC')
	   
	    result   = JSON.parse(result.to_json(:include => [:tutorial_subjects]))

	    render json: result, status: 200

  	end

  	def get_topic_type_subject_detail_list

      paramlink       = params[:topic]

      topic_data  		= Topic.where("slug = ?", paramlink).first
	  conditions      = "topic_id = #{topic_data.id} AND parent_id IS NULL" 

	   subject_result = TutorialSubject.where(conditions).order('name ASC')
      #abort(category_result.to_json)
      topic_subject_data = []

      subject_result.each_with_index do |d, k|

        subject_result = TutorialSubject.where('parent_id = ?', d.id).order('name ASC')

        data = Hash.new

        data[:topic_subject] = d
        data[:topic_sub_subject] = subject_result
        topic_subject_data.push data

      end

	    render json: {'topic_data': topic_data, 'tags': topic_data.tags, 'topic_subject_data': topic_subject_data}, status: 200  

  end

  def delete_tutorial_post
        id                   =  params[:tutorial_id]
        viewtype             =  params[:viewtype]
        if id.present?
          id.each do |id|
            
            if viewtype != "trash"
                @is_tutorial_exist     =  Tutorial.where(id: id).first
                  if @is_tutorial_exist.present?
                      Tutorial.where(id: id).update_all(:is_trash => 1) 
                      flash[:notice] = 'Tutorial has successfully trashed.' 
                  end
            else
                @is_tutorial_exist     =  is_tutorial_exist.where(id: id).first
                  if @is_tutorial_exist.present?
                      Tutorial.where(id: id).delete_all
                      flash[:notice] = 'Tutorial has successfully deleted.' 
                  end

            end  
          end

          render :json => {'res' => 1, 'message' => 'Tutorial has successfully trashed'}, status: 200 
        end
    end

  def new
      @tutorial = Tutorial.new
  end

  def edit
      @tutorial = Tutorial.find_by(paramlink: params[:paramlink])

      render 'new'
  end

  def create

        title = params['tutorial']['title']
        slugVal = create_slug(title)

        final_slug = check_slug_available(slugVal, slugVal, 0, tutorial_id = 0)

        random_tutorial_id                = get_rendom_tutorial_id
        params['tutorial']['tutorial_id'] = random_tutorial_id



        params['tutorial']['paramlink'] = final_slug
        params['tutorial']['user_id']   = current_user.id.to_s
        params['tutorial']['is_admin']  = 'N'

        if params['commit'] == 'Publish'
            params['tutorial']['is_save_to_draft'] = 0

        elsif params['commit'] == 'SaveDraft'
            params['tutorial']['is_save_to_draft'] = 1
        end 

        @tutorial = Tutorial.new(tutorial_params)

        if @tutorial.save

            tags_list = params['tutorial']['tag']['tag']
            tags_list.reject!{|a| a==""}

            tags_list.each do |tag_val|

                Tag.create(
                    tag: tag_val, 
                    tagable_id: @tutorial['id'], 
                    tagable_type: 'Tutorial'
                )

            end
            
            ############################################
         
            if params[:tutorial][:crop_x].present?
                @tutorial.company_logo = @tutorial.company_logo.resize_and_crop
                @tutorial.save!
                @tutorial.company_logo.recreate_versions!
            end
            ############################################


            ################ Store chapter data and its media content start #############
            if params[:chapter].present?

              params[:chapter].each_with_index do |chapter_data, k|

                media_content = chapter_data[1][:media_contents_attributes]
                @chapter = Chapter.create(title: chapter_data[1][:title], tutorial_id: @tutorial['id'], image: chapter_data[1][:image])

                if !@chapter['id'].nil?
                  media_content.each_with_index do |media_data, k1|
                    MediaContent.create(mediacontent: media_data[1][:mediacontent], mediacontentable_id: @chapter['id'], mediacontentable_type: 'Chapter', media_type: media_data[1][:media_type], video_duration: media_data[1][:video_duration], media_description: media_data[1][:media_description])
                  end
                end

              end

            end
            ################ Store chapter data and its media content end #############

            redirect_to index_tutorial_path, notice: 'Tutorial Successfully Created.'

        else
            render 'new'
        end    

  end

  def update
    
        @tutorial = Tutorial.find_by(paramlink: params[:paramlink])

        title = params['tutorial']['title']

        slugVal = create_slug(title)

        final_slug = check_slug_available(slugVal, slugVal, 0, tutorial_id = @tutorial.id.to_s)

        params['tutorial']['paramlink'] = final_slug

        
        if params['commit'] == 'Publish'
            params['tutorial']['is_save_to_draft'] = 0

        elsif params['commit'] == 'SaveDraft'
            params['tutorial']['is_save_to_draft'] = 1
        end
        
        if @tutorial.update(tutorial_params)

            #to delete all previous tags
            Tag.where("tagable_id = ? AND tagable_type = 'Tutorial'", @tutorial['id']).delete_all

            #to add new tags
            tags_list = params['tutorial']['tag']['tag']
            tags_list.reject!{|a| a==""}
            tags_list.each do |tag_val|

               Tag.create(
                    tag: tag_val, 
                    tagable_id: @tutorial['id'], 
                    tagable_type: 'Tutorial'
                ) 

            end 

            ############################################
          
            if params[:tutorial][:crop_x].present?
                @tutorial.company_logo = @tutorial.company_logo.resize_and_crop
                @tutorial.save!
                @tutorial.company_logo.recreate_versions!
            end
            ############################################

            ################ Store chapter data and its media content start #############
            if params[:chapter].present?

              params[:chapter].each_with_index do |chapter_data, k|

                media_content = chapter_data[1][:media_contents_attributes]
                @chapter = Chapter.create(title: chapter_data[1][:title], tutorial_id: @tutorial['id'], image: chapter_data[1][:image])
                
                if !@chapter['id'].nil?
                  media_content.each_with_index do |media_data, k1|
                    MediaContent.create(mediacontent: media_data[1][:mediacontent], mediacontentable_id: @chapter['id'], mediacontentable_type: 'Chapter', media_type: media_data[1][:media_type], video_duration: media_data[1][:video_duration], media_description: media_data[1][:media_description])
                  end
                end

              end

            end
            ################ Store chapter data and its media content end #############

            ######## to delete Chapter start ###########
            if params['tutorial']['removedChapter'].present?
              removed_chapter_array = params[:tutorial][:removedChapter].split(',')
              if removed_chapter_array.present?
                Chapter.where("id IN (?)", removed_chapter_array).delete_all
              end
            end
            ######## to delete MediaContent end ############

            ######## to delete MediaContent start ###########
            if params['tutorial']['removedMediaContent'].present?
              removed_media_content_array = params[:tutorial][:removedMediaContent].split(',')
              if removed_media_content_array.present?
                MediaContent.where("id IN (?)", removed_media_content_array).delete_all
              end
            end
            ######## to delete MediaContent end ############

            ################ Store chapter data and its media content start #############
            if params[:chapter_default].present?

              params[:chapter_default].each_with_index do |chapter_data, k|

                @chapter_update = Chapter.find_by(id: chapter_data[0])
                @chapter_update.update(title: chapter_data[1][:title], image: chapter_data[1][:image])

                media_content = chapter_data[1][:media_contents_attributes]

                if !media_content.nil?
                  media_content.each_with_index do |media_data, k1|

                    if media_data[1][:id] == ''

                      MediaContent.create(mediacontent: media_data[1][:mediacontent], mediacontentable_id: chapter_data[0], mediacontentable_type: 'Chapter', media_type: media_data[1][:media_type], video_duration: media_data[1][:video_duration], media_description: media_data[1][:media_description])

                    else

                      @media_content_update = MediaContent.find_by(id: media_data[1][:id])
                      
                      @media_content_update.update(mediacontent: media_data[1][:mediacontent], media_type: media_data[1][:media_type], video_duration: media_data[1][:video_duration], media_description: media_data[1][:media_description])
                    end

                  end
                end

              end

            end
            ################ Store chapter data and its media content end #############


            redirect_to index_tutorial_path, notice: 'Tutorial Successfully Updated.'

        else
            render 'new'
        end    
  end

  def show
        
        @paramlink                       =  params[:paramlink]
        @tutorial_data                  =  Tutorial.where('paramlink = ?', @paramlink).first

       
        #abort(@download_data.to_json)
        @product_avg_rating             =  Rating.where('product_id = ? AND post_type = ?', @tutorial_data.id, 'tutorial').pluck("AVG(rating) as avg_rate")

        @collection     = Collection.new
        
        @has_user_already_given_rating = 0
        @is_purchased = false
        if current_user.present?
          @has_user_already_given_rating  =  Rating.where('user_id = ? AND product_id=? AND post_type = ?', current_user.id, @tutorial_data.id, 'tutorial').count 

          purchased_product = PurchasedTutorial.where('user_id = ? AND tutorial_id = ?', current_user.id, @tutorial_data.id).limit(1).count

          if purchased_product > 0
            @is_purchased = true
          end  
        end    
  end


    def get_usertutorial_list
    
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
        result = Tutorial.where(conditions).order('id DESC')
        #abort(result.to_json)
        render :json => result.to_json, status: 200

  end

  def count_user_tutorial_post

        conditions = "user_id=#{current_user.id} AND is_admin != 'Y'"

        r_data = Tutorial.where(conditions)

        total_count = r_data.count
        total_trash = total_featured = total_published = total_draft = 0

        r_data.each do |val|

          if val['is_featured'] == TRUE
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

  	def all_topic_type
  	end

  	def tutorial_detail
  	end

  	def tutorial_subject
  	end

  	def tutorial_sub_subject
  	end

    def make_trash
         #abort(params.to_json)
         paramlink             =  params[:paramlink]
         @is_exist     =  Tutorial.where(paramlink: paramlink).first
        # abort(@is_gallery_exist.to_json)
         if @is_exist.present?
            Tutorial.where('id = ?',@is_exist.id).update_all(:is_trash => 1)  
            flash[:notice] = 'Tutorial has successfully trashed.'
            redirect_to index_tutorial_path
         end
          
  end

  def delete_from_trash

       paramlink  =  params[:paramlink]
       @is_exist  =  Tutorial.where(paramlink: paramlink).first
       if @is_exist.present?
          Tutorial.where('id = ?',@is_exist.id).delete_all
          flash[:notice] = 'Tutorial has successfully deleted.'
          redirect_to index_tutorial_path
       end
  end

    def restore_tutorial
       
       paramlink             =  params[:paramlink]
       @is_tutorial_exist         =  Tutorial.where(paramlink: paramlink).first
      
       if @is_tutorial_exist.present?
          Tutorial.where('id = ?',@is_tutorial_exist.id).update_all(:is_trash => 0)  
          flash[:notice] = 'Tutorial has successfully restored.'
          redirect_to index_tutorial_path
       end
    end



    def get_topic_subject_detail
        slug =  params[:topic]
          subject_data =   TutorialSubject.where('slug = ?', slug).first

          sub_subject_list =  TutorialSubject.where('parent_id = ?', subject_data.id).select("tutorial_subjects.*, (SELECT COUNT(*) FROM tutorials WHERE sub_sub_topic::jsonb ?| array[cast(tutorial_subjects.id as text)] AND status=1 AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))) AS count_tutorials").order('name ASC')
          #abort(sub_category_result.to_json)
           tags_list = Tag.where('tagable_id = ? AND tagable_type = ?' , subject_data.id, 'Tutorial')
        render json: {'subject_data': subject_data, 'sub_subject_list': sub_subject_list, 'tags_list': tags_list}, status: 200 
    end

    def get_filter_values
      max_price =   Tutorial.pluck('max(price)').first
      render json: {'max_price': max_price}, status: 200 
    end

    def get_tutorial_subject_list

      conditions = "true "
      if(params[:topic_id] && params[:topic_id] != '' && params[:topic_id] != 'all') 

        if params[:topic_id].kind_of?(Array)
          
          conditions += " AND parent_id IS NULL AND topic_id IN (" + params[:topic_id].map(&:inspect).join(',').gsub('"','') + ")"
        else
          conditions += " AND parent_id IS NULL AND topic_id=" + params[:topic_id]
        end  
      
      elsif(params[:parent_id] && params[:parent_id] != '' && params[:parent_id] != 'all') 

        if params[:parent_id].kind_of?(Array)
          conditions += " AND parent_id IN (" + params[:parent_id].map(&:inspect).join(',').gsub('"','') + ")"
        else
          conditions += " AND parent_id=" + params[:parent_id]
        end

      end

      result = TutorialSubject.where(conditions).order('name ASC')
      render json: result, status: 200 
    end

    def get_topic_subject_tutorials_list

    tutorial_data = []

    if ((params[:category_id].present? && !params[:category_id].nil?) || (params[:sub_category_id].present? && !params[:sub_category_id].nil?))

      conditions = "true "

      if params[:category_id].present? && !params[:category_id].nil?
        category_id     =  params[:category_id]
        conditions      +=  " AND sub_topic::jsonb ?| array['" + category_id.to_s + "'] "
      end

      if params[:sub_category_id].present? && !params[:sub_category_id].nil?
        sub_category_id =  params[:sub_category_id]
        conditions      +=  " AND sub_sub_topic::jsonb ?| array['" + sub_category_id.to_s + "'] "
      end

      if params[:min_price].present? && !params[:min_price].nil?
        min_price     =  params[:min_price]
        conditions    +=  " AND price >= #{min_price} "
      end

      if params[:max_price].present? && !params[:max_price].nil?
        max_price     =  params[:max_price]
        conditions    +=  " AND price <= #{max_price} "
      end

      order_by = 'id DESC'
      if params[:order_by].present? && params[:order_by].downcase == 'asc'
        order_by = 'id ASC'
      end

      tutorial_result   =  Tutorial.where(conditions).order(order_by)

      tutorial_data   = JSON.parse(tutorial_result.to_json(:include => [:user]))

    end

      render json: {'tutorial_data': tutorial_data}, status: 200  

  end

  def get_topic_list

    conditions = "true "
    if(params[:parent_id] && params[:parent_id] != '' && params[:parent_id] != 'all') 
      conditions += " AND parent_id=" + params[:parent_id]
    else
      conditions += " AND parent_id IS NULL "
    end

    result = Topic.where(conditions).order('name ASC')
   
    result   = JSON.parse(result.to_json(:include => [:tutorial_subjects]))

    render json: result, status: 200

  end


  def save_like
          tutorial_id    = params[:tutorial_id]
          artist_id      = params[:artist_id]
          user_id        = current_user.id
          
          tutorialrecord  = Tutorial.where("id = ?",tutorial_id).first
          is_admin        = tutorialrecord.is_admin.to_s
          
          is_like_exist   = PostLike.where(user_id: user_id, post_id: tutorial_id, post_type: 'Tutorial', is_admin: is_admin).first
         
          result          = ''

          activity_type = ''
          if is_like_exist.present?
                activity_type = 'disliked'
                PostLike.where(user_id: user_id, post_id: tutorial_id, post_type: 'Tutorial', is_admin: is_admin).delete_all 
                
                Notification.where(user_id: user_id,  artist_id: artist_id,  post_id: tutorial_id, notification_type: "like", section_type: 'Tutorial', is_admin: is_admin).delete_all
                
                newlike_count  =  (tutorialrecord.like_count == 0) ? 0 : tutorialrecord.like_count - 1
                tutorialrecord.update(like_count: newlike_count) 

                result  = {'res' => 0, 'message' => 'Post has disliked'}

          else
                activity_type = 'liked'
                PostLike.create(user_id: user_id, artist_id: artist_id, post_id: tutorial_id, post_type: 'Tutorial', is_admin: is_admin)  
                
                newlike_count  =  tutorialrecord.like_count + 1
                tutorialrecord.update(like_count: newlike_count) 

                Notification.create(user_id: user_id,  artist_id: artist_id,  post_id: tutorial_id, notification_type: "like", is_read: 0, section_type: 'Tutorial', is_admin: is_admin)
                 result  = {'res' => 1, 'message' => 'Post has liked'}

          end 

          LatestActivity.create(user_id: user_id,  artist_id: artist_id,  post_id: tutorial_id, activity_type: activity_type, section_type: 'Tutorial', is_admin: is_admin)  
          render json: result, status: 200       
    end  

     def check_save_like

          tutorial_id     = params[:tutorial_id]
          tutorialrecord  = Tutorial.where("id = ?",tutorial_id).first
          is_admin        = tutorialrecord.is_admin.to_s
       
          user_id         = current_user.id
          is_like_exist   = PostLike.where(user_id: user_id, post_id: tutorial_id, post_type: 'Tutorial', is_admin: is_admin).first
          result = ''
          if is_like_exist.present?
                result  = {'res' => 1, 'message' => 'Post has already liked'}
          else
                result  = {'res' => 0, 'message' => 'Post has not liked'}
          end 
          render json: result, status: 200    
             
    end

    def check_follow_artist
          artist_id          = params[:artist_id].to_i
          tutorial_id        = params[:tutorial_id]
          tutorialrecord     = Tutorial.where("id = ?",tutorial_id).first
          is_admin           = tutorialrecord.is_admin.to_s

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
        
          artist_id          = params[:artist_id].to_i
          tutorial_id        = params[:tutorial_id]
          tutorialrecord     = Tutorial.where("id = ?",tutorial_id).first
          is_admin           = tutorialrecord.is_admin.to_s

          user_id            = current_user.id
          is_follow_exist    = Follow.where(user_id: user_id, artist_id: artist_id, post_type: '', is_admin: is_admin).first
          result = ''
          
          if is_admin == 'N'
               userrecord          = User.where(id: artist_id).first
          else
               userrecord          = AdminUser.where(id: artist_id).first
          end    

          #abort(userrecord.to_json)

          if is_follow_exist.present?
                Follow.where(user_id: user_id, artist_id: artist_id, post_type: '', is_admin: is_admin).delete_all 
                Notification.where(user_id: user_id,  artist_id: artist_id, notification_type: "follow user", section_type: 'Tutorial', is_admin: is_admin).delete_all  
                newfollow_count  =  (userrecord.follow_count == 0) ? 0 : userrecord.follow_count - 1
                userrecord.update(follow_count: newfollow_count) 

                result  = {'res' => 0, 'message' => 'Artist Not Follow'}
          else
                Follow.create(user_id: user_id, artist_id: artist_id, post_type: '', is_admin: is_admin)
                Notification.create(user_id: user_id,  artist_id: artist_id,  post_id: "", notification_type: "follow user", is_read: 0, section_type: 'Tutorial', is_admin: is_admin)  

                newfollow_count  =  userrecord.follow_count + 1
                userrecord.update(follow_count: newfollow_count) 

                result  = {'res' => 1, 'message' => 'Artist Follow'}

          end 

        
          render json: result, status: 200    
             
    end

    def mark_spam
    	tutorial_id_for_mark_spam    = params[:id]
	    tutorialdata  = Tutorial.where(id: tutorial_id_for_mark_spam).first
	    if tutorialdata.is_spam == true 
	        tutorialdata.update(is_spam: false) 
	        Report.where(user_id: current_user.id, post_id: tutorial_id_for_mark_spam, post_type: 'Tutorial', report_issue: 'Spam').delete_all

	        render :json => {'res' => 0, 'message' => 'Operation is successfully done'}, status: 200 

	    else  
	        
	        Report.create(user_id: current_user.id, post_id: tutorial_id_for_mark_spam, post_type: 'Tutorial', report_issue: 'Spam')
	        tutorialdata.update(is_spam: true) 
	        render :json => {'res' => 1, 'message' => 'Operation is successfully done'}, status: 200 
	    end
	end  


  	def check_mark_spam
    	tutorial_id_for_mark_spam    = params[:id]
    	tutorialdata                 = Tutorial.where(id: tutorial_id_for_mark_spam).first
    	#abort(jobdata.to_json)
    	if tutorialdata.is_spam == true 
    	    render :json => {'res' => 1, 'message' => 'tutorial is spam'}, status: 200 
   	 	else  
        	render :json => {'res' => 2, 'message' => 'tutorial is not a spam'}, status: 200 
    	end   
  	end 

    def save_tutorial_rating

       product_id   =  params[:product_id]
       score        =  params[:score]
       post_type    =  params[:post_type]
       user_id      =  current_user.id
     
       Rating.create(product_id: product_id, rating: score, post_type: post_type, user_id: user_id)
       result = {'res' => 1, 'message' => 'Rating successfully created', 'ratingdata' => score}
       render json: result, status: 200 
    end

    def get_tutorial_avg_rating
      
      postid    =   params[:product_id]
      product_avg_rating    =  Rating.where('product_id = ? AND post_type = ?', postid, 'tutorial').pluck("AVG(rating) as avg_rate")
      render json: {'ratingdata': product_avg_rating}, status: 200  
    end 

    def save_comment
          post_id           = params[:tutorial_id]
          description       = params[:description]
          section_type      = params[:section_type]

          tutorialrecord     = Tutorial.where("id = ?",post_id).first
          is_admin          = tutorialrecord.is_admin.to_s
         
          PostComment.create(title: "", description: description, user_id: current_user.id, post_id: post_id, section_type: section_type, is_admin: is_admin) 
         

          newcomment_count_count      = tutorialrecord.comment_count + 1
          tutorialrecord.update(comment_count: newcomment_count_count) 
          
          Notification.create(user_id: current_user.id, post_id: post_id, artist_id: tutorialrecord.user_id, section_type: section_type, notification_type: "comment", is_admin: is_admin) 

          render :json => {'res' => 1, 'message' => 'Comment has successfully sent'}, status: 200
    end  

    def get_comment

          tutorial_id          = params[:tutorial_id]
          section_type         = params[:section_type]

          tutorialrecord        = Tutorial.where("id = ?",tutorial_id).first

          is_admin             = tutorialrecord.is_admin.to_s

          commentrecord        = PostComment.where("post_id = ? AND section_type=? AND is_admin=?",tutorial_id,section_type,is_admin).order('id DESC')
          
          str = ''
          if commentrecord.present?
             
            commentrecord.each_with_index do |value, index|
    
              str += '<div class="customer-wrap clearfix"><div class="customerleft"><img src = ' + value.user.image.user_activity.url + ' alt= "user"></div><div class="customerright"><div class="day-txt"><span>' + value.user.firstname + '</span> '+ DateTime.parse(value.created_at.to_s).strftime("%Y-%m-%d %H:%M:%S").to_s + '</div> <div class="date-txt">' + value.description + ' </div></div></div>'
              end
         end 
        render :json => {'res' => 1, 'data' => str, 'message' => 'data get successfully'}, status: 200   
    end
    
  	private

	  	def get_rendom_tutorial_id
	      random_tutorial_id = ([*'A'..'Z'] + [*'a'..'z'] + [*'0'..'9']).shuffle.take(10).join
	      result            = Tutorial.where('tutorial_id = ?', random_tutorial_id).count

	      if result == 0
	          return random_tutorial_id
	      else
	          get_rendom_tutorial_id
	      end  
	  	end

	  	def check_slug_available(slugVal, newSlugVal, i, tutorial_id)

	        result = Tutorial.where('id != ? AND paramlink = ?', tutorial_id, newSlugVal).count

	        if result == 0
	            return newSlugVal
	        else
	            i = i + 1
	            newSlugVal = slugVal + '-' + i.to_s
	            check_slug_available(slugVal, newSlugVal, i, tutorial_id)
	        end  

	    end

      def set_data
        @topic = Topic.where('parent_id IS NULL').order('name ASC')
        @software_expertise = SoftwareExpertise.where("parent_id IS NULL").order('name ASC').pluck(:name, :id)
      end

	    def tutorial_params
#abort(params.inspect)
	        params.require(:tutorial).permit(:title, :use_tag_from_previous_upload, :tutorial_id, :has_adult_content, :user_id, :is_admin, :paramlink, :language, :description, :skill_level, :total_lecture, :show_on_cgmeetup,:show_on_website, :schedule_time, :price, :free, {:topic => []}, {:sub_topic => []}, {:sub_sub_topic => []}, {:software_used => []} , :tags, :is_featured, :status, :is_save_to_draft, :visibility, :publish, :company_logo)
	    end

end
