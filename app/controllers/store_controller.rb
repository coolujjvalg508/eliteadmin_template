class StoreController < ApplicationController
	before_action :authenticate_user!, only: [:index]
  def index
  	user_id = current_user.id
  	@coupon_detail = Coupon.where(user_id: user_id)
    #@latest_downloads=Download.where(user_id: user_id).order('created_at DESC').limit(10)
    #@user=User.where(user_id: user_id)
  end
  def new_coupon
  end
  def create_coupon
  	  user_id = current_user.id
      @coupon_tab = "initiate"
      @exist_coupon_code = Coupon.find_by(coupon_code: params[:coupon_code], user_id: user_id)

        if !@exist_coupon_code.present?
            if params[:coupon_code].present? && params[:discount_value].present? && params[:no_of_use].present?
            
                Coupon.create(coupon_code: params[:coupon_code], discount_value: params[:discount_value],
                discount_type: params[:discount_type], no_of_use: params[:no_of_use], valid_from: params[:valid_from],
                valid_till: params[:valid_till], status: true, is_admin: 'N' , user_id: user_id)
               
               result = {'res' => 1, 'message' => 'Coupon has successfully created'}
            else
                result = {'res' => 0, 'message' => 'Oops! Something went wrong. Please try again.'}
            end
        else
            result = {'res' => 2, 'message' => 'Coupon is already exist'}
        end

        render json: result, status: 200 
           
    #abort(params[:coupon_code].to_json

  end
  def coupon_present
   
        user_id = current_user.id
        @exist_coupon_code = Coupon.find_by(coupon_code: params[:coupon_code], user_id: user_id)

        if @exist_coupon_code.present?
            result = {'res' => 0, 'message' => 'Coupon already exist'}
        else
            result = {'res' => 1, 'message' => 'New Coupon'}
        end

        render json: result, status: 200 
  end
  def coupon_delete
      
      @coupon_data = Coupon.find(params[:format])
      @coupon_data.destroy
      flash[:notice]= "Coupon successfully deleted."
      redirect_to(:action => 'index') 
  end

end
