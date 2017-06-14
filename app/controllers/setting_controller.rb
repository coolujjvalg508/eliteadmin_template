class SettingController < ApplicationController

  def index
  end
  
  def general
  end
  

  def test 
  		@lesson  =   Chapter.new

  end

  def create_test


	@lesson = Chapter.new(lesson_params)
  #abort(lesson_params.to_json)
	@lesson.save
  	abort(@lesson.inspect)
  end	
  
  private 

  def lesson_params

    params[:chapter][:tutorial_id] = 1
  	
              params.require(:chapter).permit(:title , :tutorial_id, :media_contents_attributes => [:id,:mediacontent,:media_caption,:mediacontentable_id,:mediacontentable_type, :_destroy,:tmp_mediacontent,:mediacontent_cache, :video_duration, :description, :media_type])
    end 
end
