class ContestsController < ApplicationController

	before_action :authenticate_user!, only: [:join_challenge,:index, :new, :create, :edit, :update, :get_contest_post_list]
	
	def index
	end

	
	def new
		@contest = Contest.new
	end	

	def create
		
		abort(params.to_json)

        title = params['contest']['title']

        slugVal = create_slug(title)

        final_slug = check_slug_available(slugVal, slugVal, 0, gallery_id = 0)

        #abort(params['gallery']['tag']['tag'].to_json)

        params['contest']['paramlink'] = final_slug


        if params['commit'] == 'Publish'
            params['contest']['is_save_to_draft'] = 0

        elsif params['commit'] == 'SaveDraft'
            params['contest']['is_save_to_draft'] = 1
        end 


        @contest = Contest.new(contest_params)

        if @contest.save

            
           
            tags_list = params['contest']['tag']['tag']
 
            tags_list.reject!{|a| a==""}

            tags_list.each do |tag_val|

                Tag.create(
                    tag: tag_val, 
                    tagable_id: @contest['id'], 
                    tagable_type: 'Contest'
                )

            end

             #abort(@contest.to_json)   

            ############################################
         
            if params[:contest][:crop_x].present?
                @contest.company_logo = @contest.company_logo.resize_and_crop
                @contest.save!
                @contest.company_logo.recreate_versions!
            end
            ############################################

            if params[:contest][:avatar].present?
                 caption_image  = params[:contest][:avatar_caption]
                  my_array = params[:contest][:removedids].split(',')
                 #abort(my_array.inspect)
                 params[:contest][:avatar].each.with_index do |a,index|
                   caption = ''  
                   if caption_image[index].present?
                        caption = caption_image[index]['caption_image']
                   end        


                    if !my_array.include?(index.to_s)  
                         @image = @contest.images.create!(:image => a[:image],:caption_image => caption)
                    end
                   
                 end
            end  

           #LatestActivity.create(user_id: current_user.id, artist_id: current_user.id, post_id: @contest['id'], activity_type: 'created')  
            ############################################
            redirect_to contests_path, notice: 'Contests Successfully Created.'

        else
            render 'new'
        end    

      #abort(@gallery.errors.to_json)
    

    end 

	def show
       / @contest    = Contest.find_by(paramlink: params[:paramlink])
        if @contest.post_type_category_id == 1
            render 'artshow'

         elsif  @contest.post_type_category_id == 2
            render 'videoshow'
         
         else 
            render 'show'
         
         end  /
    end  



	def get_contest_post_list
    #abort(params.to_json)
     # abort(params.to_json)
        conditions = "user_id=#{current_user.id} AND is_admin != 'Y' "

        if(params[:post_type_category_id] && params[:post_type_category_id] != '')
          conditions += ' AND post_type_category_id=' + params[:post_type_category_id]
        end 

        if(params[:medium_category_id] && params[:medium_category_id] != '')
          conditions += ' AND medium_category_id=' + params[:medium_category_id]
        end 

        result = Contest.where(conditions).order('id DESC')

        render :json => result.to_json(:include => [:category, :medium_category]), status: 200

  end


    private
        def contest_params
            params.require(:contest).permit(:user_id, :title, :description, :post_type_category_id, :medium_category_id, {:subject_matter_id => []}, {:team_member => []}, {:challenge => []}, :has_adult_content, {:software_used => []}, :paramlink, :is_admin, :use_tag_from_previous_upload, :is_featured, :show_on_cgmeetup, :show_on_website, :schedule_time , :zoom_w, :zoom_h, :zoom_x, :zoom_y, :drag_x, :drag_y, :rotation_angle, :crop_x, :crop_y, :crop_w, :crop_h, :company_logo, :publish, :visibility, :is_save_to_draft, :tags_attributes => [:id, :tag, :tagable_id, :tagable_type, :_destroy, :tmp_tag, :tag_cache], :images_attributes => [:id,:image,:caption_image,:imageable_id,:imageable_type, :_destroy,:tmp_image,:image_cache], :videos_attributes => [:id,:video,:caption_video,:videoable_id,:videoable_type, :_destroy,:tmp_image,:video_cache], :sketchfebs_attributes => [:id,:sketchfeb,:sketchfebable_id,:sketchfebable_type, :_destroy,:tmp_sketchfeb,:sketchfeb_cache,:caption_sketchfeb], :marmo_sets_attributes => [:id,:marmoset,:marmosetable_id,:marmosetable_type, :_destroy,:tmp_image,:marmoset_cache,:caption_marmoset], :upload_videos_attributes => [:id,:uploadvideo,:caption_upload_video,:uploadvideoable_id,:uploadvideoable_type, :_destroy,:tmp_image,:uploadvideo_cache])
        end

        def check_slug_available(slugVal, newSlugVal, i, contest_id)

            result = Contest.where('id != ? AND paramlink = ?', contest_id, newSlugVal).count

            if result == 0
                return newSlugVal
            else
                i = i + 1
                newSlugVal = slugVal + '-' + i.to_s
                check_slug_available(slugVal, newSlugVal, i, contest_id)
            end  

        end 







end
