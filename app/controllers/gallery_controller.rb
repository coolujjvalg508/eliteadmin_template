class GalleryController < ApplicationController
 
  def index

    #abort(current_user.to_json)

  end

  def all_gallery_post

    authenticate_user!

  end

  def get_gallery_post_list

    authenticate_user!

    conditions = "user_id=#{current_user.id} AND is_admin != 'Y' "

    if(params[:post_type_category_id] && params[:post_type_category_id] != '')
      conditions += ' AND post_type_category_id=' + params[:post_type_category_id]
    end 

    if(params[:medium_category_id] && params[:medium_category_id] != '')
      conditions += ' AND medium_category_id=' + params[:medium_category_id]
    end 

    if(params[:view]) 
      if (params[:view] == 'featured')
        conditions += ' AND is_featured=TRUE '
      elsif (params[:view] == 'published')
        conditions += ' AND publish=1'
      elsif (params[:view] == 'drafts')
        conditions += ' AND is_save_to_draft=1'
      end
    end

    #result = Gallery.where(conditions).order('id DESC').page(params[:page]).per(10)
    result = Gallery.where(conditions).order('id DESC')

    #result = result + result + result + result + result + result + result + result + result + result + result + result

    #abort(result.total_count.to_json)
    #abort(result.total_pages.to_json)


    #abort(data.to_json)
    #render json: result, status: 200  
    render :json => result.to_json(:include => [:category, :medium_category]), status: 200

  end

  def count_user_gallery_post

    authenticate_user!

    conditions = "user_id=#{current_user.id} AND is_admin != 'Y' "

    r_data = Gallery.where(conditions)

    total_count = r_data.count
    total_featured = total_published = total_draft = 0

    r_data.each do |val|

      if val['is_featured'] == TRUE
        total_featured = total_featured + 1
      end  

      if val['publish'] == 1
        total_published = total_published + 1
      end  

      if val['is_save_to_draft'] == 1
        total_draft = total_draft + 1
      end  

    end  

    result = {'total_count' => total_count, 'total_featured' => total_featured, 'total_published' => total_published, 'total_draft' => total_draft}

    render json: result, status: 200  

    #abort(result.to_json)
  end  
  

  def browse_all_artwork
  end
 
  def browse_all_awards
  end
  
  def browse_all_challenge
  end
  
  def browse_all_companies
  end
  
  def browse_all_gallery
  end
  
  def browse_all_video
  end
  
  def browse_all_work_in_progress
  end
  
  def challenge
  end

  def join_challenge
  end
  
  def challenge_post
  end
  
  def create_gallery_post_type
  end
  
  def gallery
  end
  
  def wip_detail
  end

  def download_category

  end
  def download_detail

  end

  def download_post

  end

  def search

  end
  
  def download

    @post_types = PostType.order('type_name ASC')

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

      condition_inner = "post_type_id::jsonb ?| array['" + d.id.to_s + "'] AND visibility = 0 AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone)) "
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

  
end
