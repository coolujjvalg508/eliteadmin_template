ActiveAdmin.register User do

	form multipart: true do |f|
		
		f.inputs "Basic Details" do
		  f.input :firstname
		  f.input :lastname
		  f.input :image
		  f.input :professional_headline
		  f.input :email
		  f.input :phone_number
		  f.input :profile_type, as: :select, collection: [['Artist',1],['Recruiter',2],['Studio',3]], include_blank: false, label: 'Profile Type'
		  f.input :country
		  f.input :city
		
		 f.inputs "Contact Information" do
			  f.input :show_message_button, as: :select, collection: [['Yes',1],['No',0]], include_blank: false, label: 'Show Message Button'
			  f.input :interested_in, as: :check_boxes, collection:[['Full-time employment',1],['Contract',2],['Freelance',3]]
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
				  ff.input :company_name
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
			  f.input :twitter_handle,label: 'Twitter Handle (e.g.CGMeetup)'
			  f.input :instagram_username,label: 'Instagram Username (e.g. CGMeetup)'
			  f.input :behance_username,label: 'Behance Username (e.g. CGMeetup)'
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
