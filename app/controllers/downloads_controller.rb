class DownloadsController < ApplicationController

	def download
    	@post_types = PostType.order('type_name ASC')
	end

	def free_download

     @topic_list = Category.where('parent_id IS NULL').select("categories.*, (SELECT COUNT(*) FROM downloads WHERE post_type_id::jsonb ?| array[cast(categories.id as text)] AND free IS TRUE AND status=1 AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))) AS count_downloads").order('name ASC')


     conditions  = "free IS TRUE AND status=1 AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone)) "
    
      if params[:post_type_id].present?
         conditions +=  " AND post_type_id::jsonb ?| array['" + params[:post_type_id] + "'] "
         @topic_details = Category.find_by(id: params[:post_type_id]);
      end 

      @result = Download.where(conditions).page(params[:page]).per(10)

      @result_final = JSON.parse(@result.to_json(:include => [:user]))

     # abort(@result.to_json)

  end  

  def download_category

  end

  def download_detail

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

      download_data = Download.where(condition_inner).order('id DESC').limit(4)

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

  def get_post_type_category_list
    conditions = "true "

    if(params[:post_type_id] && params[:post_type_id] != '' && params[:post_type_id] != 'all') 
      conditions += " AND parent_id IS NULL AND post_type_id=" + params[:post_type_id]
    
    elsif(params[:parent_id] && params[:parent_id] != '' && params[:parent_id] != 'all') 
      conditions += " AND parent_id=" + params[:parent_id]

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


end
