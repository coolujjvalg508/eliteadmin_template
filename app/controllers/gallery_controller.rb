class GalleryController < ApplicationController
 
  def index

    #abort(current_user.to_json)

  end

  def all_gallery_post

    authenticate_user!

  end

  def get_gallery_post_list

    authenticate_user!

    conditions = "user_id=#{current_user.id} AND is_admin='N' "

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
  
  def challenge_post
  end
  
  def create_gallery_post_type
  end
  
  def gallery
  end
  
  def wip_detail
  end
  
  def download
  end
  
end
