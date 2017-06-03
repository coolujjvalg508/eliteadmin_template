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

  def get_free_download_category_detail

         file_formats = FileFormat.select('id, name').where("status = true").order('id ASC')
        
         result =  PostTypeCategory.where("parent_id IS NULL ").select("post_type_categories.*, (SELECT COUNT(*) FROM downloads WHERE   post_type_category_id::jsonb ?| array[cast(post_type_categories.id as text)] AND status=1 AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))) AS count_downloads, (SELECT slug FROM post_types WHERE  post_types.id= post_type_categories.post_type_id limit 1) AS post_type_slug").order('name ASC')
          
         render json: {'category_list': result, 'file_formats': file_formats}, status: 200  
  end 


  def get_latest_download
    @user_id = params[:user_id]
    latest_download_data = Download.where("is_admin = ? AND user_id = ? AND status = ?",'N', @user_id, 1).order('id DESC').limit(10)
    render json: {'latest_download': latest_download_data}, status: 200
  end

  def get_latest_sale

    @user_id = params[:user_id]
    @downloads = PurchasedProduct.joins(:download).where("downloads.user_id = ? AND downloads.is_admin = 'N'", @user_id).order('id DESC')

    $final_data = []
    @downloads.each_with_index do |data, k|
    	new_data = Hash.new
    	new_data[:purchased_product] = data
    	new_data[:user] = data.user
    	new_data[:download] = data.download
    	new_data[:transaction_history] = data.transaction_history
    	$final_data.push new_data
    end
    render json: {'latest_sale': $final_data}, status: 200

  end

  def get_monthly_summary

    @user_id = params[:user_id]
    
    @monthly_summary = []
    if @user_id 
      @monthly_summary = PurchasedProduct.joins(:download).where("downloads.user_id = ? AND downloads.is_admin = 'N' AND purchased_products.created_at IS NOT NULL", @user_id).select("SUM(purchased_products.price) AS total_price, (DATE_TRUNC('month', (purchased_products.created_at::timestamptz - INTERVAL '0 hour') AT TIME ZONE 'Etc/UTC') + INTERVAL '0 hour') AT TIME ZONE 'Etc/UTC' AS month").group('month').order('month DESC')
    end
     
    render json: {'monthly_summary': @monthly_summary}, status: 200

  end

  def get_download_info

      paramlink     =   params[:paramlink]

      download_data = Download.where("paramlink=?",paramlink).first
      download      = JSON.parse(download_data.to_json(:include => [:images, :user,:videos,:sketchfebs,:marmo_sets,:upload_videos,:zip_files]))
      data   = []
      data1  = []
     # abort(download_data.to_json)
      if download_data.post_type_category_id.present?
          download_data.post_type_category_id.reject!{|a| a==""}
        data  = PostTypeCategory.find(download_data.post_type_category_id)
      end 

      if download_data.software_used.present?
          download_data.software_used.reject!{|a| a==""}
          data1  = SoftwareExpertise.find(download_data.software_used)
      end  

   # srdata1 = []
     srdata  = []
     
      if download_data.zip_files.present?
          download_data.zip_files.each_with_index do |value, index|
            #abort(number_to_human_size(+File.size("#{value.zipfile.url}")).to_json)
               string = []
               value.software.reject!{|a| a==""}
               value.software_version.reject!{|a| a==""}
               value.renderer.reject!{|a| a==""}
               value.renderer_version.reject!{|a| a==""}
                sdata   = Hash.new
               value.software.each_with_index do |value1, index1|
                   
                   sedata  = SoftwareExpertise.where("id = ?", value1).first
                   redata  = Renderer.where("id = ?", value.renderer[index1]).first
                   string[index1]  = { 'software_name': "#{sedata.name}", 'software_version': "#{value.software_version[index1]}",'renderer': "#{redata.name}",'renderer_version': "#{value.renderer_version[index1]}", 'file_size':  number_to_human_size("#{value.zipfile.url}".size) }
              end 
               # sdata[index]      =  string
                srdata.push string
            end  


        end  

      similar_download_conditions = "paramlink !='" + paramlink  + "'"
      similar_download            = Download.where(similar_download_conditions)
      render json: {'download_data': download,'post_type_category_data': data, 'software_used_name': data1, 'similar_download': similar_download, 'zip_file_info': srdata}, status: 200  

  end 
  
  protect_from_forgery except: [:check_valid_coupon_code]

  def check_valid_coupon_code

        cartdata            =   params[:products]
        code                =   params[:couponCode]
        user_id             =   params[:user_id]
        resultcode          =   0
        is_success          =   false
        applied_products    =   []
        is_code_exist       =   Coupon.where("coupon_code = ?", code).first


        if is_code_exist.present?
            if cartdata.present?

                curtime      =  Time.now.strftime("%Y-%m-%d")
                valid_from   =  is_code_exist.valid_from.strftime("%Y-%m-%d")
                valid_till   =  is_code_exist.valid_till.strftime("%Y-%m-%d")

                if valid_from <= curtime  && curtime <= valid_till

                    is_applied  =  TransactionHistory.where("coupon_code = ? AND user_id = ?", code, user_id).count

                    if  is_applied < is_code_exist.no_of_use

                        cartdata.each_with_index do |value, index|
                                   
                            download_data   = Download.where("product_id=?", value[:sku]).first

                            if (download_data.user_id == is_code_exist.user_id) && ((download_data.is_admin == 'Y' && is_code_exist.is_admin == 'Y') || (download_data.is_admin == 'N' && is_code_exist.is_admin == 'N'))
                                
                                is_success = true
                                applied_products.push value[:sku]
                            end 
                        end  
                    else
                        resultcode  =  3
                    end 
                else
                    resultcode  =  2
                end
            end 
        end 

        if is_success
            result =    {'res': 1, 'message': 'Coupon code appied successfully', 'data': is_code_exist, 'applied_products': applied_products}
        elsif resultcode  ==  2
            result =    {'res': 2, 'message': 'Coupon is not valid for the day', 'data': '', 'applied_products': applied_products}
        elsif resultcode  ==  3
            result =    {'res': 3, 'message': 'Coupon has already used', 'data': '', 'applied_products': applied_products}
        else
            result =    {'res': 0, 'message': 'Invalid Coupon', 'data': '', 'applied_products': applied_products}
        end  

        render json: result, status: 200  
  end 

end
