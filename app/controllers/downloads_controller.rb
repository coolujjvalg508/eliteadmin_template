class DownloadsController < ApplicationController
  include AdsForPages
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :save_download_rating, :listing_index]
  before_filter :set_data, only: [:new, :create, :update, :edit]



  def find_download_id(c_id,d_id)
   collection = CollectionDetail.where("download_id = ? AND collection_id = ?", d_id,c_id).first

  end
  helper_method :find_download_id

	def download
    	@post_types   = PostType.where("parent_id IS NULL").order('type_name ASC')
	end

  def listing_index
      @postcategory = PostType.where("parent_id IS NULL").order('type_name ASC')
  end


  def download_category

  end

  def get_like_comment_view_download

          post_id           = params[:download_id]
          download_record   = Download.where("id= ?",post_id).first
          res               = {'downloadlike': download_record.like_count,'downloadcomment': download_record.comment_count,'downloadview': download_record.view_count}
          render :json => res, status: 200

  end

  def make_trash
         #abort(params.to_json)
         paramlink             =  params[:paramlink]
         @is_exist     =  Download.where(paramlink: paramlink).first
        # abort(@is_gallery_exist.to_json)
         if @is_exist.present?
            Download.where('id = ?',@is_exist.id).update_all(:is_trash => 1)
            flash[:notice] = 'Product has successfully trashed.'
            redirect_to index_download_path
         end

  end

  def delete_from_trash

       paramlink  =  params[:paramlink]
       @is_exist  =  Download.where(paramlink: paramlink).first
       if @is_exist.present?
          Download.where('id = ?',@is_exist.id).delete_all
          flash[:notice] = 'Product has successfully deleted.'
          redirect_to index_download_path
       end
  end


  def restore_download

       paramlink  =  params[:paramlink]
       @is_exist  =  Download.where(paramlink: paramlink).first

       if @is_exist.present?
          Download.where('id = ?',@is_exist.id).update_all(:is_trash => 0)
          flash[:notice] = 'Product has successfully restored.'
          redirect_to index_download_path
       end

  end


  def download_detail

  end

  def save_like
          download_id    = params[:download_id]
          artist_id      = params[:artist_id]
          user_id        = current_user.id

          downloadrecord  = Download.where("id = ?",download_id).first
          is_admin        = downloadrecord.is_admin.to_s

          is_like_exist   = PostLike.where(user_id: user_id, post_id: download_id, post_type: 'Download', is_admin: is_admin).first

          result          = ''

          activity_type = ''
          if is_like_exist.present?
                activity_type = 'disliked'
                PostLike.where(user_id: user_id, post_id: download_id, post_type: 'Download', is_admin: is_admin).delete_all

                Notification.where(user_id: user_id,  artist_id: artist_id,  post_id: download_id, notification_type: "like", section_type: 'Download', is_admin: is_admin).delete_all

                newlike_count  =  (downloadrecord.like_count == 0) ? 0 : downloadrecord.like_count - 1
                downloadrecord.update(like_count: newlike_count)

                result  = {'res' => 0, 'message' => 'Post has disliked'}

          else
                activity_type = 'liked'
                PostLike.create(user_id: user_id, artist_id: artist_id, post_id: download_id, post_type: 'Download', is_admin: is_admin)

                newlike_count  =  downloadrecord.like_count + 1
                downloadrecord.update(like_count: newlike_count)

                Notification.create(user_id: user_id,  artist_id: artist_id,  post_id: download_id, notification_type: "like", is_read: 0, section_type: 'Download', is_admin: is_admin)
                 result  = {'res' => 1, 'message' => 'Post has liked'}

          end

          LatestActivity.create(user_id: user_id,  artist_id: artist_id,  post_id: download_id, activity_type: activity_type, section_type: 'Download', is_admin: is_admin)
          render json: result, status: 200
    end

     def check_save_like

          download_id     = params[:download_id]
          downloadrecord  = Download.where("id = ?",download_id).first
          is_admin        = downloadrecord.is_admin.to_s

          user_id         = current_user.id
          is_like_exist   = PostLike.where(user_id: user_id, post_id: download_id, post_type: 'Download', is_admin: is_admin).first
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
          download_id        = params[:download_id]
          downloadrecord     = Download.where("id = ?",download_id).first
          is_admin           = downloadrecord.is_admin.to_s

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
          download_id        = params[:download_id]
          downloadrecord     = Download.where("id = ?",download_id).first
          is_admin           = downloadrecord.is_admin.to_s

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
                Notification.where(user_id: user_id,  artist_id: artist_id, notification_type: "follow user", section_type: 'Download', is_admin: is_admin).delete_all
                newfollow_count  =  (userrecord.follow_count == 0) ? 0 : userrecord.follow_count - 1
                userrecord.update(follow_count: newfollow_count)

                result  = {'res' => 0, 'message' => 'Artist Not Follow'}
          else
                Follow.create(user_id: user_id, artist_id: artist_id, post_type: '', is_admin: is_admin)
                Notification.create(user_id: user_id,  artist_id: artist_id,  post_id: "", notification_type: "follow user", is_read: 0, section_type: 'Download', is_admin: is_admin)

                newfollow_count  =  userrecord.follow_count + 1
                userrecord.update(follow_count: newfollow_count)

                result  = {'res' => 1, 'message' => 'Artist Follow'}

          end


          render json: result, status: 200

    end

    def save_view_count

       if params[:download_id].present?
            download_id      = params[:download_id]
            record          = Download.where("id = ?",download_id).first

            prevoius_view_count   = record.view_count
            newview_count         =  prevoius_view_count + 1

            result = record.update(view_count: newview_count)
       end
       render json: result, status: 200
    end

    def delete_download_post
        id                   =  params[:delete_id]
        viewtype             =  params[:viewtype]
        if id.present?
          id.each do |id|

            if viewtype != "trash"
                @is_gallery_exist     =  Download.where(id: id).first
                  if @is_gallery_exist.present?
                      Download.where(id: id).update_all(:is_trash => 1)
                      flash[:notice] = 'Download has successfully trashed.'
                  end
            else
                @is_gallery_exist     =  Download.where(id: id).first
                  if @is_gallery_exist.present?
                      Download.where(id: id).delete_all
                      flash[:notice] = 'Download has successfully deleted.'
                  end

            end
          end

          render :json => {'res' => 1, 'message' => 'Download has successfully trashed'}, status: 200
        end
    end

    def make_trash
         #abort(params.to_json)
         paramlink             =  params[:paramlink]
         @is_download_exist     =  Download.where(paramlink: paramlink).first
        # abort(@is_gallery_exist.to_json)
         if @is_download_exist.present?
            Download.where('id = ?',@is_download_exist.id).update_all(:is_trash => 1)
            flash[:notice] = 'Download has successfully trashed.'
            redirect_to index_download_path
         end

    end


  def delete_from_trash

       paramlink             =  params[:paramlink]
       @is_download_exist         =  Download.where(paramlink: paramlink).first
      # abort(@is_gallery_exist.to_json)
       if @is_download_exist.present?
          Download.where('id = ?',@is_download_exist.id).delete_all
          flash[:notice] = 'Download has successfully deleted.'
          redirect_to index_download_path
       end
  end

  def mark_spam
    download_id_for_mark_spam    = params[:id]
    downloaddata  = Download.where(id: download_id_for_mark_spam).first
    if downloaddata.is_spam == true
        downloaddata.update(is_spam: false)
        Report.where(user_id: current_user.id, post_id: download_id_for_mark_spam, post_type: 'Download', report_issue: 'Spam').delete_all

        render :json => {'res' => 0, 'message' => 'Operation is successfully done'}, status: 200

    else

        Report.create(user_id: current_user.id, post_id: download_id_for_mark_spam, post_type: 'Download', report_issue: 'Spam')
        downloaddata.update(is_spam: true)
        render :json => {'res' => 1, 'message' => 'Operation is successfully done'}, status: 200
    end
  end


  def check_mark_spam
    download_id_for_mark_spam    = params[:id]
    downloaddata                 = Download.where(id: download_id_for_mark_spam).first
    #abort(jobdata.to_json)
    if downloaddata.is_spam == true
        render :json => {'res' => 1, 'message' => 'download is spam'}, status: 200
    else
        render :json => {'res' => 2, 'message' => 'download is not a spam'}, status: 200
    end
  end

  def restore_download

       paramlink             =  params[:paramlink]
       @is_download_exist         =  Download.where(paramlink: paramlink).first

       if @is_download_exist.present?
          Download.where('id = ?',@is_download_exist.id).update_all(:is_trash => 0)
          flash[:notice] = 'Download has successfully restored.'
          redirect_to index_download_path
       end

  end

    def save_comment
          post_id           = params[:download_id]
          description       = params[:description]
          section_type      = params[:section_type]

          galleryrecord     = Download.where("id = ?",post_id).first
          is_admin          = galleryrecord.is_admin.to_s

          PostComment.create(title: "", description: description, user_id: current_user.id, post_id: post_id, section_type: section_type, is_admin: is_admin)


          newcomment_count_count      = galleryrecord.comment_count + 1
          galleryrecord.update(comment_count: newcomment_count_count)

          Notification.create(user_id: current_user.id, post_id: post_id, artist_id: galleryrecord.user_id, section_type: section_type, notification_type: "comment", is_admin: is_admin)

          render :json => {'res' => 1, 'message' => 'Comment has successfully sent'}, status: 200
    end

    def get_comment

          download_id          = params[:download_id]

          section_type         = params[:section_type]

          galleryrecord        = Download.where("id = ?",download_id).first
          is_admin             = galleryrecord.is_admin.to_s

          commentrecord        = PostComment.where("post_id = ? AND section_type=? AND is_admin=?",download_id,section_type,is_admin).order('id DESC')
          #abort(commentrecord.to_json)
          str = ''
          if commentrecord.present?

            commentrecord.each_with_index do |value, index|

              str += '<div class="customer-wrap clearfix"><div class="customerleft"><img src = ' + value.user.image.user_activity.url + ' alt= "user"></div><div class="customerright"><div class="day-txt"><span>' + value.user.firstname + '</span> '+ DateTime.parse(value.created_at.to_s).strftime("%Y-%m-%d %H:%M:%S").to_s + '</div> <div class="date-txt">' + value.description + ' </div></div></div>'
##
              end


         end

        render :json => {'res' => 1, 'data' => str, 'message' => 'data get successfully'}, status: 200
    end


  def show

        @paramlink                       =  params[:paramlink]
        @download_data                  =  Download.where('paramlink = ?', @paramlink).first


        #abort(@download_data.to_json)
        @product_avg_rating             =  Rating.where('product_id = ? AND post_type = ?', @download_data.id, 'download').pluck("AVG(rating) as avg_rate")

        @collection     = Collection.new


        #abort(current_user.id.to_json)
        if(current_user!=nil)
          @collections = Collection.where('user_id = ?',current_user.id)
        end



        #@collection_details = CollectionDetail.where('collection_id = ?',@download_data.id).first
        #abort(@collection_details.to_json)


        #abort(@collection1.to_json)
        #abort(@download_data.to_json)

        #@collections = @download_data.

        #@download_collection = @download_data.collection
        #abort(@download_collection.to_json)

        @has_user_already_given_rating = 0
        @is_purchased = false
        if current_user.present?
          @has_user_already_given_rating  =  Rating.where('user_id = ? AND product_id=? AND post_type = ?', current_user.id, @download_data.id, 'download').count

          purchased_product = PurchasedProduct.where('user_id = ? AND download_id = ?', current_user.id, @download_data.id).limit(1).count

          if purchased_product > 0
            @is_purchased = true
          end
        end
    get_ads("downloads")    
  end

  def get_download_avg_rating

      postid    =   params[:product_id]
      product_avg_rating    =  Rating.where('product_id = ? AND post_type = ?', postid, 'download').pluck("AVG(rating) as avg_rate")
      render json: {'ratingdata': product_avg_rating}, status: 200
  end


  def download_post

  end

  def get_download_list

    conditions = "true "

    if(params[:post_type_id] && params[:post_type_id] != '' && params[:post_type_id] != 'all')
      conditions += " AND id=" + params[:post_type_id]
    end

    post_types = PostType.where(conditions).order('type_name ASC')

    #abort(post_types[0].to_json)

    final_data = []

    i = 0
    post_types.each_with_index do |d, k|


      #download_data = Download.where("post_type_id::jsonb ? '1'")
      #condition_inner = "post_type_id::jsonb ?| array['1', '2'] AND visibility = 0 AND publish = 1"

      condition_inner = "post_type_id::jsonb ?| array['" + d.id.to_s + "'] AND visibility = 0 AND status = 1 AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone)) "
      #condition_inner = "post_type_id::jsonb ?| array['" + d.id.to_s + "']"

      if(params[:is_feature] && params[:is_feature] != '' && params[:is_feature] != 'all')
         condition_inner += " AND is_feature=" + params[:is_feature]
      end

      if(params[:post_type_category_id] && params[:post_type_category_id] != '' && params[:post_type_category_id] != 'all')
         condition_inner += " AND post_type_category_id::jsonb ?| array['" + params[:post_type_category_id] + "'] "
      end

      if(params[:sub_category_id] && params[:sub_category_id] != '' && params[:sub_category_id] != 'all')
        condition_inner += " AND sub_category_id::jsonb ?| array['" + params[:sub_category_id] + "'] "
      end

      # For sorting data when user vists from Features section on Home page
      cols_for_order = 'id DESC'
      if params[:sort]
        case params[:sort]
        when "top"
          cols_for_order = 'view_count DESC, id DESC'
        end
      end
      # condition for ordering data ends here
      download_data = Download.where(condition_inner).order(cols_for_order).limit(4)

      download = JSON.parse(download_data.to_json(:include => [:images, :user]))

      #abort(download.to_json)

      if download_data.present?
        final_data[i] = {'PostType' => d, 'Download' => download}
        i = i + 1
      end

    end

    #abort(final_data.to_json)
    render json: final_data, status: 200

  end

  def count_user_download_post

        conditions = "user_id=#{current_user.id} AND is_admin != 'Y'"

        r_data = Download.where(conditions)

        total_count = r_data.count
        total_trash = total_featured = total_published = total_draft = 0

        r_data.each do |val|

          if val['is_feature'] == TRUE
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

  def get_userdownload_list

        conditions = "user_id=#{current_user.id} AND is_admin != 'Y'"

        if(params[:post_type] && params[:post_type] != '')
            conditions += " AND post_type_id::jsonb ?| array['" + params[:post_type] + "'] "
        end

        # if(params[:job_category] && params[:job_category] != '')
        #    conditions += " AND job_category::jsonb ?| array['" + params[:job_category] + "'] "
        # end



        if(params[:view])
          if (params[:view] == 'featured')
            conditions += ' AND is_feature=TRUE  AND is_trash = 0'
          elsif (params[:view] == 'published')
            conditions += ' AND publish=1  AND is_trash = 0'
          elsif (params[:view] == 'drafts')
            conditions += ' AND is_save_to_draft=1  AND is_trash = 0'
          elsif (params[:view] == 'trash')
            conditions += ' AND is_trash=1'
          end
        end


       #abort(conditions.to_json)
        result = Download.where(conditions).order('id DESC')
        #abort(result.to_json)
        render :json => result.to_json, status: 200

  end
  def get_post_type_category_list

    #abort(params[:post_type_id].inspect)

    conditions = "true "
    if(params[:post_type_id] && params[:post_type_id] != '' && params[:post_type_id] != 'all')

      if params[:post_type_id].kind_of?(Array)

        conditions += " AND parent_id IS NULL AND post_type_id IN (" + params[:post_type_id].map(&:inspect).join(',').gsub('"','') + ")"
      else
        conditions += " AND parent_id IS NULL AND post_type_id=" + params[:post_type_id]
      end

    elsif(params[:parent_id] && params[:parent_id] != '' && params[:parent_id] != 'all')

      if params[:parent_id].kind_of?(Array)
        conditions += " AND parent_id IN (" + params[:parent_id].map(&:inspect).join(',').gsub('"','') + ")"
      else
        conditions += " AND parent_id=" + params[:parent_id]
      end

    end

    result = PostTypeCategory.where(conditions).order('name ASC')
    render json: result, status: 200
  end

  def get_post_type_list

    conditions = "true "
    if(params[:parent_id] && params[:parent_id] != '' && params[:parent_id] != 'all')
      conditions += " AND parent_id=" + params[:parent_id]
    else
      conditions += " AND parent_id IS NULL "
    end

    result = PostType.where(conditions).order('type_name ASC')

    result   = JSON.parse(result.to_json(:include => [:post_type_categories]))

    render json: result, status: 200

  end

  def get_post_type_category_detail_list

      paramlink       = params[:post_type]
      post_type_data  = PostType.where("slug = ?", paramlink).first
      #abort(post_type_data.to_json)
		  conditions      = "post_type_id = #{post_type_data.id} AND parent_id IS NULL"

	    category_result = PostTypeCategory.where(conditions).order('name ASC')
      #abort(category_result.to_json)
      post_type_category_data = []

      category_result.each_with_index do |d, k|

        category_result = PostTypeCategory.where('parent_id = ?', d.id).order('name ASC')

        data = Hash.new

        data[:post_type_category] = d
        data[:post_type_sub_categories] = category_result
        post_type_category_data.push data

      end

	    render json: {'post_type_data': post_type_data, 'tags': post_type_data.tags, 'post_type_category_data': post_type_category_data}, status: 200

  end

  def get_post_type_category_detail
        #  abort(params.to_json)

          category_type =  params[:category_type]
          category_data =   PostTypeCategory.where('slug = ?', category_type).first

          sub_category_list =  PostTypeCategory.where('parent_id = ?', category_data.id).select("post_type_categories.*, (SELECT COUNT(*) FROM downloads WHERE sub_category_id::jsonb ?| array[cast(post_type_categories.id as text)] AND status=1 AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))) AS count_downloads").order('name ASC')
          #abort(sub_category_result.to_json)


        render json: {'category_data': category_data, 'sub_category_list': sub_category_list}, status: 200
  end

  def get_filter_values

    max_price =   Download.pluck('max(price)').first

    file_formats = FileFormat.select('id, name').where("status = true").order('id ASC')

    render json: {'max_price': max_price, file_formats: file_formats}, status: 200

  end


  def get_post_type_category_downloads_list

    download_data = []

    if ((params[:category_id].present? && !params[:category_id].nil?) || (params[:sub_category_id].present? && !params[:sub_category_id].nil?))

      conditions = "true "

      if params[:category_id].present? && !params[:category_id].nil?
        category_id     =  params[:category_id]
        conditions      +=  " AND post_type_category_id::jsonb ?| array['" + category_id.to_s + "'] "
      end

      if params[:sub_category_id].present? && !params[:sub_category_id].nil?
        sub_category_id =  params[:sub_category_id]
        conditions      +=  " AND sub_category_id::jsonb ?| array['" + sub_category_id.to_s + "'] "
      end

      if params[:min_price].present? && !params[:min_price].nil?
        min_price     =  params[:min_price]
        conditions    +=  " AND price >= #{min_price} "
      end

      if params[:max_price].present? && !params[:max_price].nil?
        max_price     =  params[:max_price]
        conditions    +=  " AND price <= #{max_price} "
      end

      if params[:file_format].present? && !params[:file_format].nil?
        file_format_id     =  params[:file_format]
        conditions    +=  " AND file_format_id = #{file_format_id} "
      end

      if params[:animated].present? && params[:animated] == 'true'
        conditions    +=  " AND animated = true "
      end

      if params[:texture].present? && params[:texture] == 'true'
        conditions    +=  " AND texture = true "
      end

      if params[:material].present? && params[:material] == 'true'
        conditions    +=  " AND material = true "
      end

      if params[:lowpoly].present? && params[:lowpoly] == 'true'
        conditions    +=  " AND lowpoly = true "
      end

      if params[:rigged].present? && params[:rigged] == 'true'
        conditions    +=  " AND rigged = true "
      end

      if params[:free].present? && params[:free] == 'true'
        conditions    +=  " AND free = true "
      end

      if params[:plugin_used].present? && params[:plugin_used] == 'true'
        conditions    +=  " AND plugin_used = true "
      end

      order_by = 'id DESC'
      if params[:order_by].present? && params[:order_by].downcase == 'asc'
        order_by = 'id ASC'
      end

      download_result   =  Download.where(conditions).order(order_by)

      download_data   = JSON.parse(download_result.to_json(:include => [:user]))

    end

      render json: {'download_data': download_data}, status: 200

  end


  def all_post_type


  end


  def get_free_category_downloads_list

      download_data = []

      conditions = "free = true"

      if params[:file_format].present? && !params[:file_format].nil?
        file_format_id     =  params[:file_format]
        conditions    +=  " AND file_format_id = #{file_format_id} "
      end

      if params[:animated].present? && params[:animated] == 'true'
        conditions    +=  " AND animated = true "
      end

      if params[:texture].present? && params[:texture] == 'true'
        conditions    +=  " AND texture = true "
      end

      if params[:material].present? && params[:material] == 'true'
        conditions    +=  " AND material = true "
      end

      if params[:lowpoly].present? && params[:lowpoly] == 'true'
        conditions    +=  " AND lowpoly = true "
      end

      if params[:rigged].present? && params[:rigged] == 'true'
        conditions    +=  " AND rigged = true "
      end

      if params[:plugin_used].present? && params[:plugin_used] == 'true'
        conditions    +=  " AND plugin_used = true "
      end

      order_by = 'id DESC'
      if params[:order_by].present? && params[:order_by].downcase == 'asc'
        order_by = 'id ASC'
      end

      download_result   =  Download.where(conditions).order(order_by)

      download_data   = JSON.parse(download_result.to_json(:include => [:user]))

      render json: {'download_data': download_data}, status: 200

  end

  def download_sub_category

  end

  def new
      @download = Download.new
  end

  def edit
      @download = Download.find_by(paramlink: params[:paramlink])
      render 'new'
  end

  def get_rendom_product_id
      random_product_id = ([*'A'..'Z'] + [*'a'..'z'] + [*'0'..'9']).shuffle.take(10).join
      result            = Download.where('product_id = ?', random_product_id).count

      if result == 0
          return random_product_id
      else

          get_rendom_product_id
      end


  end

  def create

        title = params['download']['title']
        slugVal = create_slug(title)

        final_slug = check_slug_available(slugVal, slugVal, 0, download_id = 0)

        random_product_id                = get_rendom_product_id
        params['download']['product_id'] = random_product_id



        params['download']['paramlink'] = final_slug
        params['download']['user_id']   = current_user.id.to_s
        params['download']['is_admin']  = 'N'

        if params['commit'] == 'Publish'
            params['download']['is_save_to_draft'] = 0

        elsif params['commit'] == 'SaveDraft'
            params['download']['is_save_to_draft'] = 1
        end

        @download = Download.new(download_params)

        if @download.save

            tags_list = params['download']['tag']['tag']
            tags_list.reject!{|a| a==""}

            tags_list.each do |tag_val|

                Tag.create(
                    tag: tag_val,
                    tagable_id: @download['id'],
                    tagable_type: 'Download'
                )

            end

             #abort(@gallery.to_json)

            ############################################

            if params[:download][:crop_x].present?
                @download.company_logo = @download.company_logo.resize_and_crop
                @download.save!
                @download.company_logo.recreate_versions!
            end
            ############################################

            if params[:download][:avatar].present?
                 caption_image  = params[:download][:avatar_caption]
                  my_array = params[:download][:removedids].split(',')
                 #abort(my_array.inspect)
                 params[:download][:avatar].each.with_index do |a,index|
                   caption = ''
                   if  !caption_image.nil? && caption_image[index].present?
                        caption = caption_image[index]['caption_image']
                   end
                    if !my_array.include?(index.to_s)
                         @image = @download.images.create!(:image => a[:image],:caption_image => caption)
                    end

                 end
            end

            if params[:download][:custom_zip].present?
                zip_caption  = params[:download][:zip_caption]

                software_renderer = []
                if params[:download][:software_renderer].present?
                  software_renderer  = params[:download][:software_renderer]
                end

                my_array = params[:download][:removedZipNew].split(',')
                #abort(my_array.inspect)
                params[:download][:custom_zip].each.with_index do |a,index|
                  caption = ''
                  if  !zip_caption.nil? && zip_caption[index].present?
                      caption = zip_caption[index]['zip_caption']
                  end

                  software = []
                  software_version = []
                  renderer = []
                  renderer_version = []

                  if !software_renderer.nil? && software_renderer[index.to_s].present?

                    software_renderer[index.to_s].each_with_index do |file_data, f_key|

                      software.push file_data[1]['software']
                      software_version.push file_data[1]['software_version']
                      renderer.push file_data[1]['renderer']
                      renderer_version.push file_data[1]['renderer_version']

                    end

                  end

                  if !my_array.include?(index.to_s)
                      @image = @download.zip_files.create!(:zipfile => a[:zipfile], :zip_caption => caption, :software => software, :software_version => software_version, :renderer => renderer, :renderer_version => renderer_version)
                  end

                end
            end

            redirect_to index_download_path, notice: 'Product Successfully Created.'

        else
            render 'new'
        end

  end

  def update

        @download = Download.find_by(paramlink: params[:paramlink])

        title = params['download']['title']

        slugVal = create_slug(title)

        final_slug = check_slug_available(slugVal, slugVal, 0, download_id = @download.id.to_s)

        params['download']['paramlink'] = final_slug


        if params['commit'] == 'Publish'
            params['download']['is_save_to_draft'] = 0

        elsif params['commit'] == 'SaveDraft'
            params['download']['is_save_to_draft'] = 1
        end

        if @download.update(download_params)

            ############ Images update start #################
            #to delete images
            if params['download']['removedimages'].present?
              removedimages_array = params[:download][:removedimages].split(',')
              if removedimages_array.present?
                Image.where("id IN (?)", removedimages_array).delete_all
              end
            end

            #to update caption of existing images
            if params['download']['images_attributes_default'].present?
              params['download']['images_attributes_default'].each do |data_update|
                Image.where('id = ?', data_update[0]).update_all(:caption_image => data_update[1]['caption_image'])
              end
            end

            ############ Images update end #################

            ############ Video url update start #################

            #to delete video url
            if params['download']['removedvideourl'].present?
              removedvideourl_array = params[:download][:removedvideourl].split(',')
              if removedvideourl_array.present?
                Video.where("id IN (?)", removedvideourl_array).delete_all
              end
            end

            #to update caption of existing video url
            if params['download']['videos_attributes_default'].present?
              params['download']['videos_attributes_default'].each do |data_update|
                Video.where('id = ?', data_update[0]).update_all(:caption_video => data_update[1]['caption_video'])
              end
            end

            ############ Video url update end #################

            ############ sketchfab update start #################

            #to delete Sketchfeb
            if params['download']['removedsketchfab'].present?
              removedsketchfab_array = params[:download][:removedsketchfab].split(',')
              if removedsketchfab_array.present?
                Sketchfeb.where("id IN (?)", removedsketchfab_array).delete_all
              end
            end

            #to update caption of existing sketchfebs url
            if params['download']['sketchfebs_attributes_default'].present?
              params['download']['sketchfebs_attributes_default'].each do |data_update|
                Sketchfeb.where('id = ?', data_update[0]).update_all(:caption_sketchfeb => data_update[1]['caption_sketchfeb'])
              end
            end

            ############ sketchfab update end #################

            ############ upload video update start #################

            #to delete upload video
            if params['download']['removedUploadVideo'].present?
              removed_upload_video_array = params[:download][:removedUploadVideo].split(',')
              if removed_upload_video_array.present?
                UploadVideo.where("id IN (?)", removed_upload_video_array).delete_all
              end
            end

            #to update caption of existing upload video
            if params['download']['upload_videos_attributes_default'].present?
              params['download']['upload_videos_attributes_default'].each do |data_update|
                UploadVideo.where('id = ?', data_update[0]).update_all(:caption_upload_video => data_update[1]['caption_upload_video'])
              end
            end

            ############ upload video update end #################

            ############ marmoset update start #################

            #to delete upload video
            if params['download']['removedMarmoset'].present?
              removed_marmoset_array = params[:download][:removedMarmoset].split(',')
              if removed_marmoset_array.present?
                MarmoSet.where("id IN (?)", removed_marmoset_array).delete_all
              end
            end

            #to update caption of existing upload video
            if params['download']['marmo_sets_attributes_default'].present?
              params['download']['marmo_sets_attributes_default'].each do |data_update|
                MarmoSet.where('id = ?', data_update[0]).update_all(:caption_marmoset => data_update[1]['caption_marmoset'])
              end
            end

            ############ marmoset update end #################

            ############ zip update start #################

            #to delete zip
            if params['download']['removedZip'].present?
              removed_zip_array = params[:download][:removedZip].split(',')
              if removed_zip_array.present?
                ZipFile.where("id IN (?)", removed_zip_array).delete_all
              end
            end

            #to update caption of existing zip
            if params['download']['zip_files_attributes_default'].present?
              i = 0

              #abort(params['download']['zip_files_attributes_default']['18'].inspect)

              params['download']['zip_files_attributes_default'].each_with_index do |data_update, k|

                #abort(data_update.inspect)


                software = []
                software_version = []
                renderer = []
                renderer_version = []

                data_update[1]['software_renderer'].each_with_index do |file_data, k1|

                  #abort(file_data[1]['software'].to_json)

                  software.push file_data[1]['software']
                  software_version.push file_data[1]['software_version']
                  renderer.push file_data[1]['renderer']
                  renderer_version.push file_data[1]['renderer_version']

                end

                ZipFile.where('id = ?', data_update[0]).update_all(:zip_caption => data_update[1]['zip_caption'], :software => software.to_json, :software_version => software_version.to_json, :renderer => renderer.to_json, :renderer_version => renderer_version.to_json)

                i = i + 1
              end
            end

            ############ zip update end #################


            #to delete all previous tags
            Tag.where("tagable_id = ? AND tagable_type = 'Download'", @download['id']).delete_all

            #to add new tags
            tags_list = params['download']['tag']['tag']
            tags_list.reject!{|a| a==""}
            tags_list.each do |tag_val|

               Tag.create(
                    tag: tag_val,
                    tagable_id: @download['id'],
                    tagable_type: 'Download'
                )

            end

            ############################################

            if params[:download][:crop_x].present?
                @download.company_logo = @download.company_logo.resize_and_crop
                @download.save!
                @download.company_logo.recreate_versions!
            end
            ############################################

            if params[:download][:avatar].present?
                 caption_image  = params[:download][:avatar_caption]
                 my_array = params[:download][:removedids].split(',')

                 params[:download][:avatar].each.with_index do |a,index|
                   caption = ''
                   if caption_image[index].present?
                        caption = caption_image[index]['caption_image']
                   end

                    if !my_array.include?(index.to_s)
                         @image = @download.images.create!(:image => a[:image],:caption_image => caption)
                    end

                 end
            end

            if params[:download][:custom_zip].present?
                zip_caption  = params[:download][:zip_caption]

                software_renderer = []
                if params[:download][:software_renderer].present?
                  software_renderer  = params[:download][:software_renderer]
                end

                my_array = params[:download][:removedZipNew].split(',')
                #abort(my_array.inspect)
                params[:download][:custom_zip].each.with_index do |a,index|
                  caption = ''
                  if  !zip_caption.nil? && zip_caption[index].present?
                      caption = zip_caption[index]['zip_caption']
                  end

                  software = []
                  software_version = []
                  renderer = []
                  renderer_version = []

                  if !software_renderer.nil? && software_renderer[index.to_s].present?

                    software_renderer[index.to_s].each_with_index do |file_data, f_key|

                      software.push file_data[1]['software']
                      software_version.push file_data[1]['software_version']
                      renderer.push file_data[1]['renderer']
                      renderer_version.push file_data[1]['renderer_version']

                    end

                  end

                  if !my_array.include?(index.to_s)
                      @image = @download.zip_files.create!(:zipfile => a[:zipfile], :zip_caption => caption, :software => software, :software_version => software_version, :renderer => renderer, :renderer_version => renderer_version)
                  end

                end
            end

            redirect_to index_download_path, notice: 'Product Successfully Updated.'

        else
            render 'new'
        end
  end


  def save_download_rating

     product_id   =  params[:product_id]
     score        =  params[:score]
     post_type    =  params[:post_type]
     user_id      =  current_user.id

     Rating.create(product_id: product_id, rating: score, post_type: post_type, user_id: user_id)
     result = {'res' => 1, 'message' => 'Rating successfully created', 'ratingdata' => score}
     render json: result, status: 200
  end


  def cart

  end

  protect_from_forgery except: [:update_number_of_downloads]
  def update_number_of_downloads

    download_data    =  Download.where('id = ?', params['id']).first

    if !download_data.nil?
      number_of_download = 1
      if !download_data.number_of_download.nil?
        number_of_download = download_data.number_of_download.to_i + 1
      end
      download_data.update(number_of_download: number_of_download)
    end

    result = {'res' => 1, 'message' => 'Number of downloads updated successfully'}
    render json: result, status: 200

  end

  private
    def download_params

          #abort(params.inspect)

          #abort(params[:download][:zip_files_attributes].inspect)

          if params[:download][:zip_files_attributes].present?

            i = 0
            params[:download][:zip_files_attributes].each_with_index do |files_attributes, key|

              software = []
              software_version = []
              renderer = []
              renderer_version = []


              files_attributes[1]['software_renderer'].each_with_index do |file_data, f_key|

                software.push file_data[1]['software']
                software_version.push file_data[1]['software_version']
                renderer.push file_data[1]['renderer']
                renderer_version.push file_data[1]['renderer_version']

              end

              #abort(software.to_json)

              #abort(params[:download][:zip_files_attributes][i.to_s].inspect)

              params[:download][:zip_files_attributes][i.to_s][:software] = software.to_json
              params[:download][:zip_files_attributes][i.to_s][:software_version] = software_version.to_json
              params[:download][:zip_files_attributes][i.to_s][:renderer] = renderer.to_json
              params[:download][:zip_files_attributes][i.to_s][:renderer_version] = renderer_version.to_json

              i = i + 1

            end
          end

          #abort(params[:download][:zip_files_attributes].inspect)

          params.require(:download).permit(:title, :use_tag_from_previous_upload, :product_id, :animated, :texture, :plugin_used, :material, :rigged, :lowpoly, :uv_mapping, :unwrapped_uv, :polygon, :geometry, :license_type, :license_custom_info, :changelog, :vertice, :unit, :has_adult_content,  :user_id, :is_admin, :paramlink, :description, :show_on_cgmeetup,:show_on_website, :schedule_time, :price, :free, {:post_type_id => []}, {:post_type_category_id => []}, {:sub_category_id => []}, {:software_used => []} , :tags, :is_feature, :status, :is_save_to_draft, :visibility, :publish, :company_logo, :images_attributes => [:id,:image,:caption_image,:imageable_id,:imageable_type, :_destroy,:tmp_image,:image_cache], :videos_attributes => [:id,:video,:caption_video,:videoable_id,:videoable_type, :_destroy,:tmp_image,:video_cache], :upload_videos_attributes => [:id,:uploadvideo,:caption_upload_video,:uploadvideoable_id,:uploadvideoable_type, :_destroy,:tmp_image,:uploadvideo_cache], :sketchfebs_attributes => [:id,:sketchfeb,:sketchfebable_id,:sketchfebable_type, :_destroy,:tmp_sketchfeb,:sketchfeb_cache], :marmo_sets_attributes => [:id,:marmoset,:marmosetable_id,:marmosetable_type, :_destroy,:tmp_image,:marmoset_cache], :company_attributes => [:id,:name], :zip_files_attributes => [:id,:zipfile, :zipfileable_id, :zipfileable_type, :_destroy, :tmp_zipfile, :zipfile_cache, :zip_caption, :software, :software_version, :renderer, :renderer_version],:tags_attributes => [:id,:tag,:tagable_id,:tagable_type, :_destroy,:tmp_tag,:tag_cache])
    end

    def check_slug_available(slugVal, newSlugVal, i, download_id)

        result = Download.where('id != ? AND paramlink = ?', download_id, newSlugVal).count

        if result == 0
            return newSlugVal
        else
            i = i + 1
            newSlugVal = slugVal + '-' + i.to_s
            check_slug_available(slugVal, newSlugVal, i, download_id)
        end

    end

    def set_data
      @post_type = PostType.where('parent_id IS NULL').order('type_name ASC')
      @software_expertise = SoftwareExpertise.where("parent_id IS NULL").order('name ASC').pluck(:name, :id)
      @renderer = Renderer.where("parent_id IS NULL").order('name ASC').pluck(:name, :id)
    end

end
