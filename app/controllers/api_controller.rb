class ApiController < ApplicationController

  def get_software_expertises_list

      conditions = ' true '

      if params[:parent_id].present? && !params[:parent_id].nil?
          conditions    +=  " AND parent_id = #{params[:parent_id]} "
      else
          conditions    +=  " AND parent_id IS NULL "
      end

      data =  SoftwareExpertise.where(conditions).order('name ASC')

      render json: {'data': data}, status: 200  

  end

  def get_renderers_list

      conditions = ' true '

      if params[:parent_id].present? && !params[:parent_id].nil?
          conditions    +=  " AND parent_id = #{params[:parent_id]} "
      else
          conditions    +=  " AND parent_id IS NULL "
      end

      data =  Renderer.where(conditions).order('id ASC')

      render json: {'data': data}, status: 200  

  end

end
