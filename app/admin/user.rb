ActiveAdmin.register User do
   menu label: 'Front Users', parent: 'Users'
	permit_params :firstname, :username, :password,:lastname,:image,:professional_headline,:email,:phone_number, :profile_type, :country, :city,:show_message_button, :full_time_employment, :contract , :freelance, :available_from,:summary, :demo_reel,:skill_expertise, :software_expertise, :public_email_address, :website_url, :facebook_url, 
	:linkedin_profile_url,:twitter_handle,:instagram_username ,:behance_username,:tumbler_url,:pinterest_url, :youtube_url, :vimeo_url, :google_plus_url, :stream_profile_url, :professional_experiences_attributes => [:company_id,:title,:location,:description, :from_month,:from_year,:to_month,:to_year,:currently_worked], :production_experiences_attributes => [:production_title,:release_year,:production_type,:your_role, :company], :education_experiences_attributes => [:school_name,:field_of_study,:month_val,:year_val, :description], :company_attributes => [:id,:name]



	action_item only: :edit do
		user		  	    =	User.find_by(id: params[:id]) 
		if(user.is_deleted == 1)
			link_to "Permit User", 'javascript:void(0);', method: :get, id: 'removebanned',title: params[:id]
		else
			link_to "Restrict User", 'javascript:void(0);', method: :get, id: 'userbanned',title: params[:id]
		end
		
	end


	
	collection_action :user_ban, method: :get do
		id   				=	params[:id]
		user		  	    =	User.find_by(id: id)
		user.update(is_deleted: 1)	
		flash[:success] = "User has successfully restricted."
		render json: {message: 'ok',status: '200'}

	end
	
	collection_action :remove_user_ban, method: :get do
		id   				=	params[:id]
		user		  	    =	User.find_by(id: id) 
		user.update(is_deleted: 0)	
		flash[:success] = "User has successfully permitted."
		render json: {message: 'ok',status: '200'}

	end
	
	
	controller do 
		def action_methods
		 super                                    
			if current_admin_user.id.to_s == '1'
			super
		  else
			usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
			disallowed = []
			disallowed << 'index' if (!usergroup.has_permission('user_read') && !usergroup.has_permission('user_write') && !usergroup.has_permission('user_delete'))
			disallowed << 'delete' unless (usergroup.has_permission('user_delete'))
			disallowed << 'create' unless (usergroup.has_permission('user_write'))
			disallowed << 'new' unless (usergroup.has_permission('user_write'))
			disallowed << 'edit' unless (usergroup.has_permission('user_write'))
			disallowed << 'destroy' unless (usergroup.has_permission('user_delete'))
			
			super - disallowed
		  end
	end
  end
  



	form multipart: true do |f|
		
		f.inputs "Basic Details" do
		  f.input :firstname
		  f.input :lastname
		  f.input :username
		   f.input :profile_type, as: :select, collection: [['Artist','Artist'],['Recruiter','Recruiter'],['Studio','Studio']], include_blank: false, label: 'Profile Type'
		  #f.input :group_id, as: :select, collection:  UserGroup.where("name != '' ").pluck(:name, :id),include_blank:'Select Group'		
		  f.input :password
		  f.input :image
		  f.input :professional_headline
		  f.input :email
		  f.input :phone_number
		 
		  f.input :country
		  f.input :city
		
		  f.inputs "Contact Information" do
			  f.input :show_message_button, as: :select, collection: [['Yes',1],['No',0]], include_blank: false, label: 'Show Message Button'
			  f.input :full_time_employment, as: :boolean,label: "Full-time employment"
			  f.input :contract, as: :boolean,label: "Contract"
			  f.input :freelance, as: :boolean,label: "Freelance"
			  f.input :available_from, as: :date_time_picker
			 
		 end	
		 f.inputs "Professional Summary" do
			  f.input :summary
			 
		 end	
		 f.inputs "Demo Reel" do
			  f.input :demo_reel
			 
		 end	
		 
		 f.inputs "Professional Experience" do
			 f.has_many :professional_experiences, allow_destroy: true, new_record: true do |ff|
				  ff.input :company_id, as: :select, collection: Company.where("name != '' ").pluck(:name, :id),include_blank:'Select Company Name'				
				  ff.input :title
				  ff.input :location
				  ff.input :description
				  ff.input :from_month, as: :select, collection: [['January',1],['February',2],['March',3],['April',4],['May',5],['June',6],['July',7],['August',8],['September',9],['October',10],['November',11],['December',12]] , include_blank: false, label: 'From Month'
				  ff.input :from_year
				  ff.input :to_month, as: :select, collection: [['January',1],['February',2],['March',3],['April',4],['May',5],['June',6],['July',7],['August',8],['September',9],['October',10],['November',11],['December',12]] , include_blank: false, label: 'To Month'
				  ff.input :to_year
				  ff.input :currently_worked, as: :check_boxes, collection:[['Yes',1]]
				
				end 
		 end
		
		f.inputs "Production Experience" do
			 f.has_many :production_experiences, allow_destroy: true, new_record: true do |ff|
				  ff.input :production_title
				  ff.input :release_year
				  ff.input :production_type, as: :select, collection: [['Movie',1]], include_blank: false, label: 'Production Type'
				  ff.input :your_role
				  ff.input :company
				
			 end 
			  
		end
		
		f.inputs "Education Experience" do
			 f.has_many :education_experiences, allow_destroy: true, new_record: true do |ff|
				  ff.input :school_name
				  ff.input :field_of_study
				  ff.input :month_val, as: :select, collection: [['January',1],['February',2],['March',3],['April',4],['May',5],['June',6],['July',7],['August',8],['September',9],['October',10],['November',11],['December',12]] , include_blank: false, label: 'Expected Graduation Month'
				  ff.input :year_val, label: 'Expected Graduation Year'
				  ff.input :description
			 end 
		 end
		
		f.inputs "Skill" do
			  f.input :skill_expertise
			  f.input :software_expertise
			 
		 end
		
		      f.inputs "Contact & Social Media" do
			  f.input :public_email_address,label: 'Public Email Address'
			  f.input :website_url,label: 'Website URL'
			  f.input :facebook_url,label: 'Facebook Page URL'
			  f.input :linkedin_profile_url,label: 'linkedin Profile URL'
			  f.input :twitter_handle,label: 'Twitter Handle'
			  f.input :instagram_username,label: 'Instagram Username'
			  f.input :behance_username,label: 'Behance Username'
			  f.input :tumbler_url,label: 'Tumblr URL'
			  f.input :pinterest_url,label: 'Pinterest URL'
			  f.input :youtube_url,label: 'Youtube URL'
			  f.input :vimeo_url,label: 'Vimeo URL'
			  f.input :google_plus_url,label: 'Google Plus URL'
			  f.input :stream_profile_url,label: 'Steam Profile URL'
			 
		 end
		 
	 end
		
	f.actions
  end
  
  
  
   controller do
	  def create
			if (params[:user].present? && params[:user][:professional_experiences_attributes].present?)
					params[:user][:professional_experiences_attributes].each do |index,img|
						  unless params[:user][:professional_experiences_attributes][index][:title].present?
								params[:user][:professional_experiences_attributes][index][:company_id] = params[:user][:professional_experiences_attributes][index][:company_id]
								params[:user][:professional_experiences_attributes][index][:title] = params[:user][:professional_experiences_attributes][index][:title]
								params[:user][:professional_experiences_attributes][index][:location] = params[:user][:professional_experiences_attributes][index][:location]
								params[:user][:professional_experiences_attributes][index][:description] = params[:user][:professional_experiences_attributes][index][:description]
								params[:user][:professional_experiences_attributes][index][:from_month] = params[:user][:professional_experiences_attributes][index][:from_month]
								params[:user][:professional_experiences_attributes][index][:to_month] = params[:user][:professional_experiences_attributes][index][:to_month]
								params[:user][:professional_experiences_attributes][index][:to_year] = params[:user][:professional_experiences_attributes][index][:to_year]
								params[:user][:professional_experiences_attributes][index][:currently_worked] = params[:user][:professional_experiences_attributes][index][:currently_worked]
						  end
						  
					end
				super
			
			elsif (params[:user].present? && params[:user][:production_experiences_attributes].present?)
					params[:user][:production_experiences_attributes].each do |index,img|
						  unless params[:user][:production_experiences_attributes][index][:production_title].present?
								params[:user][:production_experiences_attributes][index][:production_title] = params[:user][:production_experiences_attributes][index][:production_title]
								params[:user][:production_experiences_attributes][index][:release_year] = params[:user][:production_experiences_attributes][index][:release_year]
								params[:user][:production_experiences_attributes][index][:production_type] = params[:user][:production_experiences_attributes][index][:production_type]
								params[:user][:production_experiences_attributes][index][:your_role] = params[:user][:production_experiences_attributes][index][:your_role]
								params[:user][:production_experiences_attributes][index][:description] = params[:user][:production_experiences_attributes][index][:company]
							
						  end
						  
					end
				super
				
				
			elsif (params[:user].present? && params[:user][:education_experiences_attributes].present?)
					params[:user][:education_experiences_attributes].each do |index,img|
						  unless params[:user][:education_experiences_attributes][index][:school_name].present?
								params[:user][:education_experiences_attributes][index][:school_name] = params[:user][:education_experiences_attributes][index][:school_name]
								params[:user][:education_experiences_attributes][index][:field_of_study] = params[:user][:education_experiences_attributes][index][:field_of_study]
								params[:user][:education_experiences_attributes][index][:month_val] = params[:user][:education_experiences_attributes][index][:month_val]
								params[:user][:education_experiences_attributes][index][:year_val] = params[:user][:education_experiences_attributes][index][:year_val]
								params[:user][:education_experiences_attributes][index][:description] = params[:user][:education_experiences_attributes][index][:description]
								
						  end
						  
					end
				super
				
				
		 else
				super
		  end
		end

		def update
		#abort(params.to_json)
			
			if (params[:user].present? && params[:user][:professional_experiences_attributes].present?)
					params[:user][:professional_experiences_attributes].each do |index,img|
						  unless params[:user][:professional_experiences_attributes][index][:title].present?
							params[:user][:professional_experiences_attributes][index][:company_id] = params[:user][:professional_experiences_attributes][index][:company_id]
							params[:user][:professional_experiences_attributes][index][:title] = params[:user][:professional_experiences_attributes][index][:title]
							params[:user][:professional_experiences_attributes][index][:location] = params[:user][:professional_experiences_attributes][index][:location]
							params[:user][:professional_experiences_attributes][index][:description] = params[:user][:professional_experiences_attributes][index][:description]
							params[:user][:professional_experiences_attributes][index][:from_month] = params[:user][:professional_experiences_attributes][index][:from_month]
							params[:user][:professional_experiences_attributes][index][:to_month] = params[:user][:professional_experiences_attributes][index][:to_month]
							params[:user][:professional_experiences_attributes][index][:to_year] = params[:user][:professional_experiences_attributes][index][:to_year]
							params[:user][:professional_experiences_attributes][index][:currently_worked] = params[:user][:professional_experiences_attributes][index][:currently_worked]
						  end
					end
				super
			
			elsif (params[:user].present? && params[:user][:production_experiences_attributes].present?)
					params[:user][:production_experiences_attributes].each do |index,img|
						  unless params[:user][:production_experiences_attributes][index][:production_title].present?
							params[:user][:production_experiences_attributes][index][:production_title] = params[:user][:production_experiences_attributes][index][:production_title]
							params[:user][:production_experiences_attributes][index][:release_year] = params[:user][:production_experiences_attributes][index][:release_year]
							params[:user][:production_experiences_attributes][index][:production_type] = params[:user][:production_experiences_attributes][index][:production_type]
							params[:user][:production_experiences_attributes][index][:your_role] = params[:user][:production_experiences_attributes][index][:your_role]
							params[:user][:production_experiences_attributes][index][:description] = params[:user][:production_experiences_attributes][index][:company]
							
						  end
						  
					end
				super
				
				
			elsif (params[:user].present? && params[:user][:education_experiences_attributes].present?)
					params[:user][:education_experiences_attributes].each do |index,img|
						  unless params[:user][:education_experiences_attributes][index][:school_name].present?
							params[:user][:education_experiences_attributes][index][:school_name] = params[:user][:education_experiences_attributes][index][:school_name]
							params[:user][:education_experiences_attributes][index][:field_of_study] = params[:user][:education_experiences_attributes][index][:field_of_study]
							params[:user][:education_experiences_attributes][index][:month_val] = params[:user][:education_experiences_attributes][index][:month_val]
							params[:user][:education_experiences_attributes][index][:year_val] = params[:user][:education_experiences_attributes][index][:year_val]
							params[:user][:education_experiences_attributes][index][:description] = params[:user][:education_experiences_attributes][index][:description]
							
					 end
						  
					end
				super
				
				
		 else
				super
		  end
		  
		end
			
  end
  
  
  
  filter :firstname
  filter :username
  filter :email
  filter :profile_type, as: :select, collection: [['Artist','Artist'],['Recruiter','Recruiter'],['Studio','Studio']], label: 'Profile Type'
  filter :is_deleted, as: :select, collection: [['Banned',1],['Not Banned',0]], label: 'Banned User'
  filter :profile_type, as: :select, collection: [['Artist',1],['Recruiter',2],['Studio',3]], label: 'Profile Type'
  filter :created_at
  
  
    # Users List View
  index :download_links => ['csv'] do
	   selectable_column
	    column 'Image' do |img|
		  image_tag img.try(:image).try(:url, :thumb), height: 50, width: 50
		end
	    column 'First Name' do |fname|
		 fname.firstname
	    end
	    column 'Last Name' do |lname|
		 lname.lastname
	   end
	   column 'User Name' do |uname|
		 uname.username
	   end
	   column 'Profile Type' do |fname|
	 	 fname.profile_type
	    end
	   column 'Email' do |email|
		  email.email
	   end
	   column 'Country' do |country|
		  country.country? ? ISO3166::Country[country.country] : '----'
	   end
	   column 'City' do |city|
		  city.city
	   end
	   
	   column 'Banned' do |ub|
		  (ub.is_deleted == 1) ? 'YES' : 'NO'
	   end
		
		actions
  end
  
  
   show do
    attributes_table do
      row :firstname
      row :lastname
      row 'User Name' do |uname|
		 uname.username
	  end
	  row 'Profile Type' do |fname|
		 fname.profile_type
	  end 
      row :email
      row :professional_headline
      row :phone_number
      row :demo_reel
      row :country do |country|
       country.country? ? ISO3166::Country[country.country] : '----'
      end
      row :city
      row 'Banned' do |ub|
		  (ub.is_deleted == 1) ? 'YES' : 'NO'
	   end
      row :image do |cat|
        unless !cat.image.present?
          image_tag(cat.try(:image).try(:url, :event_small))
        else
          image_tag('/assets/default-blog.png', height: '50', width: '50')
        end
      end
      row :created_at
    end
  end

  



# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


end
