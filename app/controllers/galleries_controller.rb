class GalleriesController < ApplicationController

    before_action :authenticate_user!, only: [:new, :crete, :edit, :update]
 
  def index

  end 
  
  def new

    @gallery = current_user.gallery.new
  end 
  
  def create

    params['gallery']['paramlink'] = 'test'


    if params['commit'] == 'Publish'
        params['gallery']['publish'] = 1
        params['gallery']['is_save_to_draft'] = 0

    elsif params['commit'] == 'SaveDraft'
        params['gallery']['publish'] = 0
        params['gallery']['is_save_to_draft'] = 1
            
    end    

#abort(params.to_json)
    @gallery = Gallery.new(gallery_params)

    @gallery.save

    abort(@gallery.errors.to_json)

  end 
  
  def edit

  end 
  
  def update

  end

  private
    def gallery_params
      params.require(:gallery).permit(:user_id, :title, :description, :post_type_category_id, :medium_category_id, {:subject_matter_id => []}, :has_adult_content, {:software_used => []}, :paramlink, :is_admin, :use_tag_from_previous_upload, :is_featured, :show_on_cgmeetup, :show_on_website, :schedule_time, :company_logo, :publish, :visibility, :is_save_to_draft)
    end

  
end
