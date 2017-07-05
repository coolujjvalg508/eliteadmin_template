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

  def get_latest_tutorial
    @user_id = params[:user_id]
    latest_tutorial_data = Tutorial.where("is_admin = ? AND user_id = ? AND status = ?",'N', @user_id, 1).order('id DESC').limit(10)
    render json: {'latest_tutorial': latest_tutorial_data}, status: 200
  end

  def get_latest_tutorial_sale

    @user_id = params[:user_id]
    @downloads = PurchasedTutorial.joins(:tutorial).where("tutorials.user_id = ? AND tutorials.is_admin = 'N'", @user_id).order('id DESC')

    $final_data = []
    @downloads.each_with_index do |data, k|
      new_data = Hash.new
      new_data[:purchased_tutorial] = data
      new_data[:user] = data.user
      new_data[:tutorial] = data.tutorial
      new_data[:transaction_history] = data.transaction_history
      $final_data.push new_data
    end
    render json: {'latest_tutorial_sale': $final_data}, status: 200

  end


  def get_monthly_tutorial_summary

    @user_id = params[:user_id]
    
    @monthly_summary = []
    if @user_id 
      @tutorial_summary = PurchasedTutorial.joins(:tutorial).where("tutorials.user_id = ? AND tutorials.is_admin = 'N' AND purchased_tutorials.created_at IS NOT NULL", @user_id).select("SUM(purchased_tutorials.price) AS total_price, (DATE_TRUNC('month', (purchased_tutorials.created_at::timestamptz - INTERVAL '0 hour') AT TIME ZONE 'Etc/UTC') + INTERVAL '0 hour') AT TIME ZONE 'Etc/UTC' AS month").group('month').order('month DESC')
    end
     
    render json: {'tutorial_summary': @tutorial_summary}, status: 200

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

      similar_download            = Download.where("paramlink !='" + paramlink  + "' AND is_featured = 0 AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(4)
      render json: {'download_data': download,'post_type_category_data': data, 'software_used_name': data1, 'similar_download': similar_download, 'zip_file_info': srdata}, status: 200  

  end 


  def get_tutorial_info

      paramlink     =   params[:paramlink]

      tutorial_data = Tutorial.where("paramlink=?",paramlink).first

      #download      = JSON.parse(tutorial_data.to_json(:include => [:images, :user,:videos,:sketchfebs,:marmo_sets,:upload_videos,:zip_files]))
      data   = []
      data1  = []
     # abort(download_data.to_json)
      if tutorial_data.sub_sub_topic.present?
          tutorial_data.sub_sub_topic.reject!{|a| a==""}
        data  = TutorialSubject.find(tutorial_data.sub_sub_topic)
      end 

      if tutorial_data.software_used.present?
          tutorial_data.software_used.reject!{|a| a==""}
          data1  = SoftwareExpertise.find(tutorial_data.software_used)
      end  

      topic_data = []

      if tutorial_data.topic.present?
          tutorial_data.topic.reject!{|a| a==""}
          topic_data  = Topic.find(tutorial_data.topic)
      end 

   # srdata1 = []
     #srdata  = []
     
      # if download_data.zip_files.present?
      #     download_data.zip_files.each_with_index do |value, index|
      #       #abort(number_to_human_size(+File.size("#{value.zipfile.url}")).to_json)
      #          string = []
      #          value.software.reject!{|a| a==""}
      #          value.software_version.reject!{|a| a==""}
      #          value.renderer.reject!{|a| a==""}
      #          value.renderer_version.reject!{|a| a==""}
      #           sdata   = Hash.new
      #          value.software.each_with_index do |value1, index1|
                   
      #              sedata  = SoftwareExpertise.where("id = ?", value1).first
      #              redata  = Renderer.where("id = ?", value.renderer[index1]).first
      #              string[index1]  = { 'software_name': "#{sedata.name}", 'software_version': "#{value.software_version[index1]}",'renderer': "#{redata.name}",'renderer_version': "#{value.renderer_version[index1]}", 'file_size':  number_to_human_size("#{value.zipfile.url}".size) }
      #         end 
      #          # sdata[index]      =  string
      #           srdata.push string
      #       end  


      #   end  
      featured_tutorials            = Tutorial.where("is_featured = 1 AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(4)
     
      similar_tutorial            = Tutorial.where("paramlink !='" + paramlink  + "' AND is_featured = 0 AND visibility = 1 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(4)
      tutorial_data_final = JSON.parse(tutorial_data.to_json(:include => [:user]))
      featured_tutorials_final = JSON.parse(featured_tutorials.to_json(:include => [:user]))
      all_chapters_data = JSON.parse(tutorial_data.chapters.to_json(:include => [:media_contents]))
       # abort(all_chapters_data.to_json)

      @is_purchased = false

      if current_user.present?
       
        purchased_product = PurchasedTutorial.where('user_id = ? AND tutorial_id = ?', current_user.id, tutorial_data_final['id']).limit(1).count

        if purchased_product > 0
          @is_purchased = true
        end  
      end 

      render json: {'tutorial_data': tutorial_data_final , 'all_chapters_data': all_chapters_data ,'similar_tutorial': similar_tutorial, 'topic_data': topic_data   , 'tag_data': tutorial_data.tags ,'subject_data': data, 'software_used_name': data1, 'featured_tutorials': featured_tutorials_final, 'is_purchased': @is_purchased}, status: 200  

  end 

  def get_news_info

      paramlink     =   params[:paramlink]

      news_data = News.where("paramlink=? AND is_approved = ?",paramlink,'TRUE').first
      
      data   = []
      data1  = []
     # abort(download_data.to_json)
      if news_data.category_id.present?
        news_data.category_id.reject!{|a| a==""}
        data  = NewsCategory.find(news_data.category_id)
      end 

      if news_data.software_used.present?
        news_data.software_used.reject!{|a| a==""}
        data1  = SoftwareExpertise.find(news_data.software_used)
      end  

      # topic_data = []

      # if tutorial_data.topic.present?
      #     tutorial_data.topic.reject!{|a| a==""}
      #     topic_data  = Topic.find(tutorial_data.topic)
      # end 

      #condition_inner = "is_approved = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone)) "
      featured_news            = News.where("is_featured = 1 AND is_approved = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(4)
     
      similar_news            = News.where("paramlink !='" + paramlink  + "' AND is_featured = 0 AND is_approved = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(4)
      news_data_final = JSON.parse(news_data.to_json(:include => [:user]))
      featured_news_final = JSON.parse(featured_news.to_json(:include => [:user]))
      all_news_media_data = JSON.parse(news_data.news_contents.to_json(:include => [:media_contents]))
       # abort(all_chapters_data.to_json)

      # @is_purchased = false

      # if current_user.present?
       
      #   purchased_product = PurchasedTutorial.where('user_id = ? AND tutorial_id = ?', current_user.id, tutorial_data_final['id']).limit(1).count

      #   if purchased_product > 0
      #     @is_purchased = true
      #   end  
      # end 

      render json: {'news_data': news_data_final ,'similar_news': similar_news , 'news_content_data': all_news_media_data ,'category_data': data , 'tag_data': news_data.tags, 'software_used_name': data1, 'featured_news': featured_news_final}, status: 200  

  end 
  
  protect_from_forgery except: [:check_valid_coupon_code]

  def check_valid_coupon_code

        cartdata            =   params[:products]
        code                =   params[:couponCode]
        user_id             =   params[:user_id]
        resultcode          =   0
        is_success          =   false
        applied_products    =   []
        applied_tutorials   =   []
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
                                   
                            if value[:type] == 'download'

                                download_data   = Download.where("product_id=?", value[:sku]).first

                                if (download_data.user_id == is_code_exist.user_id) && ((download_data.is_admin == 'Y' && is_code_exist.is_admin == 'Y') || (download_data.is_admin == 'N' && is_code_exist.is_admin == 'N'))
                                    
                                    is_success = true
                                    applied_products.push value[:sku]
                                end

                            elsif value[:type] == 'tutorial'

                                tutorial_data   = Tutorial.where("tutorial_id=?", value[:sku]).first

                                if (tutorial_data.user_id == is_code_exist.user_id) && ((tutorial_data.is_admin == 'Y' && is_code_exist.is_admin == 'Y') || (tutorial_data.is_admin == 'N' && is_code_exist.is_admin == 'N'))
                                    
                                    is_success = true
                                    applied_tutorials.push value[:sku]
                                end

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
            result =    {'res': 1, 'message': 'Coupon code appied successfully', 'data': is_code_exist, 'applied_products': applied_products, 'applied_tutorials': applied_tutorials}
        elsif resultcode  ==  2
            result =    {'res': 2, 'message': 'Coupon is not valid for the day', 'data': '', 'applied_products': applied_products, 'applied_tutorials': applied_tutorials}
        elsif resultcode  ==  3
            result =    {'res': 3, 'message': 'Coupon has already used', 'data': '', 'applied_products': applied_products, 'applied_tutorials': applied_tutorials}
        else
            result =    {'res': 0, 'message': 'Invalid Coupon', 'data': '', 'applied_products': applied_products, 'applied_tutorials': applied_tutorials}
        end  

        render json: result, status: 200  
  end


  ########### API for home page start #################

  def get_featured_news

      featured_news = News.where("is_featured = 1 AND is_approved = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(8)
      
      render json: featured_news, status: 200  

  end

  def get_site_setting
      data = SiteSetting.first
      render json: data, status: 200  
  end

  def get_community

      filter_type = params[:type]
      home_layout_type = SiteSetting.first
      if home_layout_type.home_page_layout_type == 0
        if filter_type == 'community'
          if params[:post_type]!='null'
            if params[:post_type] == 'Wip' || params[:post_type] == 'Artwork' || params[:post_type] == 'Video'
              post_data = Category.find_by(name: params[:post_type])
              if params[:category]!='null'
                category_data = SubjectMatter.find_by(name: params[:category])   
                community_data = Gallery.where("subject_matter_id::jsonb ?| array['" + category_data.id.to_s + "'] AND post_type_category_id = "+post_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(61)
              else
                community_data = Gallery.where("post_type_category_id = "+post_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(61)
              end
            else
              medium_category_data = MediumCategory.find_by(name: params[:post_type])
              community_data = Gallery.where("medium_category_id = "+medium_category_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(61)
            end
          else 
              community_data = Gallery.where("is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(61)
          end
        elsif filter_type == 'latest'
          if params[:post_type]!='null'
            if params[:post_type] == 'Wip' || params[:post_type] == 'Artwork' || params[:post_type] == 'Video'
              post_data = Category.find_by(name: params[:post_type])
              if params[:category]!='null'
                category_data = SubjectMatter.find_by(name: params[:category])   
                community_data = Gallery.where("subject_matter_id::jsonb ?| array['" + category_data.id.to_s + "'] AND post_type_category_id = "+post_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(61)
              else
                community_data = Gallery.where("post_type_category_id = "+post_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(61)
              end
            else
              medium_category_data = MediumCategory.find_by(name: params[:post_type])
              community_data = Gallery.where("medium_category_id = "+medium_category_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(61)
            end
          else 
              community_data = Gallery.where("is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(61)
          end
        elsif filter_type == 'featured'

          if params[:post_type]!='null'
            if params[:post_type] == 'Wip' || params[:post_type] == 'Artwork' || params[:post_type] == 'Video'
              post_data = Category.find_by(name: params[:post_type])
              if params[:category]!='null'
                category_data = SubjectMatter.find_by(name: params[:category])   
                community_data = Gallery.where("subject_matter_id::jsonb ?| array['" + category_data.id.to_s + "'] AND post_type_category_id = "+post_data.id.to_s+" AND is_featured = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(61)
              else
                community_data = Gallery.where("post_type_category_id = "+post_data.id.to_s+" AND is_featured = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(61)
              end
            else
              medium_category_data = MediumCategory.find_by(name: params[:post_type])
              community_data = Gallery.where("medium_category_id = "+medium_category_data.id.to_s+" AND is_featured = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(61)
            end
          else 
              community_data = Gallery.where("is_featured = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(61)
          end
        elsif filter_type == 'wip'

          community_data = Gallery.where("post_type_category_id = 3 AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(61)
        elsif filter_type == 'contest'

          community_data = Contest.where("is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(61)
        elsif filter_type == 'trending'
          if params[:post_type]!='null'
            if params[:post_type] == 'Wip' || params[:post_type] == 'Artwork' || params[:post_type] == 'Video'
              post_data = Category.find_by(name: params[:post_type])
              if params[:category]!='null'
                category_data = SubjectMatter.find_by(name: params[:category])   
                community_data = Gallery.where("subject_matter_id::jsonb ?| array['" + category_data.id.to_s + "'] AND post_type_category_id = "+post_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('like_count DESC').limit(61)
              else
                community_data = Gallery.where("post_type_category_id = "+post_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('like_count DESC').limit(61)
              end
            else
              medium_category_data = MediumCategory.find_by(name: params[:post_type])
              community_data = Gallery.where("medium_category_id = "+medium_category_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('like_count DESC').limit(61)
            end
          else 
              community_data = Gallery.where("is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('like_count DESC').limit(61)
          end
        elsif filter_type == 'following'
          follow_data = Follow.select(:artist_id).where(user_id: current_user.id)
          follow_user_data = User.where('id IN (?)', follow_data).order('id DESC').limit(61)
        end
      else
        if filter_type == 'community'
          if params[:post_type]!='null'
            if params[:post_type] == 'Wip' || params[:post_type] == 'Artwork' || params[:post_type] == 'Video'
              post_data = Category.find_by(name: params[:post_type])
              if params[:category]!='null'
                category_data = SubjectMatter.find_by(name: params[:category])   
                community_data = Gallery.where("subject_matter_id::jsonb ?| array['" + category_data.id.to_s + "'] AND post_type_category_id = "+post_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(61)
              else
                community_data = Gallery.where("post_type_category_id = "+post_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(61)
              end
            else
              medium_category_data = MediumCategory.find_by(name: params[:post_type])
              community_data = Gallery.where("medium_category_id = "+medium_category_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(61)
            end
          else 
              community_data = Gallery.where("is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(61)
          end
        elsif filter_type == 'latest'
          if params[:post_type]!='null'
            if params[:post_type] == 'Wip' || params[:post_type] == 'Artwork' || params[:post_type] == 'Video'
              post_data = Category.find_by(name: params[:post_type])
              if params[:category]!='null'
                category_data = SubjectMatter.find_by(name: params[:category])   
                community_data = Gallery.where("subject_matter_id::jsonb ?| array['" + category_data.id.to_s + "'] AND post_type_category_id = "+post_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(61)
              else
                community_data = Gallery.where("post_type_category_id = "+post_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(61)
              end
            else
              medium_category_data = MediumCategory.find_by(name: params[:post_type])
              community_data = Gallery.where("medium_category_id = "+medium_category_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(61)
            end
          else 
              community_data = Gallery.where("is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(61)
          end
        elsif filter_type == 'featured'

          if params[:post_type]!='null'
            if params[:post_type] == 'Wip' || params[:post_type] == 'Artwork' || params[:post_type] == 'Video'
              post_data = Category.find_by(name: params[:post_type])
              if params[:category]!='null'
                category_data = SubjectMatter.find_by(name: params[:category])   
                community_data = Gallery.where("subject_matter_id::jsonb ?| array['" + category_data.id.to_s + "'] AND post_type_category_id = "+post_data.id.to_s+" AND is_featured = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(102)
              else
                community_data = Gallery.where("post_type_category_id = "+post_data.id.to_s+" AND is_featured = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(102)
              end
            else
              medium_category_data = MediumCategory.find_by(name: params[:post_type])
              community_data = Gallery.where("medium_category_id = "+medium_category_data.id.to_s+" AND is_featured = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(102)
            end
          else 
              community_data = Gallery.where("is_featured = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(102)
          end
        elsif filter_type == 'wip'

          community_data = Gallery.where("post_type_category_id = 3 AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(102)
        elsif filter_type == 'contest'

          community_data = Contest.where("is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(102)
        elsif filter_type == 'trending'
          if params[:post_type]!='null'
            if params[:post_type] == 'Wip' || params[:post_type] == 'Artwork' || params[:post_type] == 'Video'
              post_data = Category.find_by(name: params[:post_type])
              if params[:category]!='null'
                category_data = SubjectMatter.find_by(name: params[:category])   
                community_data = Gallery.where("subject_matter_id::jsonb ?| array['" + category_data.id.to_s + "'] AND post_type_category_id = "+post_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('like_count DESC').limit(102)
              else
                community_data = Gallery.where("post_type_category_id = "+post_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('like_count DESC').limit(102)
              end
            else
              medium_category_data = MediumCategory.find_by(name: params[:post_type])
              community_data = Gallery.where("medium_category_id = "+medium_category_data.id.to_s+" AND is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('like_count DESC').limit(102)
            end
          else 
              community_data = Gallery.where("is_featured = FALSE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('like_count DESC').limit(102)
          end
        elsif filter_type == 'following'
          follow_data = Follow.select(:artist_id).where(user_id: current_user.id)
          follow_user_data = User.where('id IN (?)', follow_data).order('id DESC').limit(102)
        end
      end
      if community_data.present?
        all_community_data = JSON.parse(community_data.to_json(:include => [:images]))
      end
      render json: {'community_data': all_community_data ,'follow_user_data': follow_user_data, 'home_layout_type': home_layout_type.home_page_layout_type }, status: 200 
  end
  

  def get_news_behined_scenes
      news_category = NewsCategory.find_by(name: 'Production Coverage')
      #abort(news_category.id.to_json)
     
      news_data = News.where("category_id::jsonb ?| array['" + news_category.id.to_s + "'] AND is_approved = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(4)
      #news_content_data = JSON.parse(news_data.to_json(:include => [:user]))
      render json: {'news_data': news_data ,'news_category': news_category }, status: 200  
  end

  def get_news_press_release
      news_category = NewsCategory.find_by(name: 'Industry News')
      #abort(news_category.id.to_json)
     
      news_data = News.where("category_id::jsonb ?| array['" + news_category.id.to_s + "'] AND is_approved = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(3)
      news_content_data = JSON.parse(news_data.to_json(:include => [:user]))
      render json: {'news_content_data': news_content_data ,'news_category': news_category }, status: 200  
  end

  def get_news_movies_film_trailors
      news_category = NewsCategory.find_by(name: 'Trailers')
      #abort(news_category.id.to_json)
     
      news_data = News.where("category_id::jsonb ?| array['" + news_category.id.to_s + "'] AND is_approved = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(4)
      
      render json: {'news_data': news_data ,'news_category': news_category }, status: 200  
  end

  def get_news_tutorials_free_source
      news_category = NewsCategory.find_by(name: 'Tutorials')
      #abort(news_category.id.to_json)
     
      news_data = News.where("category_id::jsonb ?| array['" + news_category.id.to_s + "'] AND is_approved = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(4)
      
      render json: {'news_data': news_data ,'news_category': news_category }, status: 200  
  end

  def get_jobs
      jobs_detail = Job.where("is_approved = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(6)
      jobs_data = JSON.parse(jobs_detail.to_json(:include => [:country]))
      
      render json: jobs_data, status: 200  
  end

  def get_downloads
      download_data = Download.where("visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(4)
      
      render json: download_data, status: 200  
  end

  def get_latest_post
      latest_post_data = Gallery.where("visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(8)
      
      render json: latest_post_data, status: 200  
  end  

  def get_top_artist
      artist_data = User.where("profile_type = ?", 'Artist').order('like_count DESC').limit(20)
      
      render json: artist_data, status: 200  
  end

  def get_post_type_category
      post_type = Category.all

      media_category = MediumCategory.all
      
      post_type_id = params[:post_id]
      #post_type_id = '1'
        if post_type_id.present?
           subject_data = SubjectMatter.where(parent_id: post_type_id) 
           
        end

      render json: {'post_type': post_type ,'media_category': media_category }, status: 200  
  end
  def get_subject_type
      
      post_type_id = params[:post_id]
      #post_type_id = '1'
        if post_type_id.present?
           subject_data = SubjectMatter.where(parent_id: post_type_id) 
           
        end

      render json: {'subject_data': subject_data }, status: 200  
  end
  def home_setting_visibility
    visibality = SiteSetting.first
    render json: {'visibality': visibality }, status: 200 
  end

  ########### API for home page end ###################


end
