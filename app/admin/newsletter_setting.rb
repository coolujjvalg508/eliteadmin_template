ActiveAdmin.register NewsletterSetting do

menu label: 'Newsletter Setting'
	permit_params :email_digest_option, :job_email,:gallery_email,:download_email,:tutorial_email,:news_email

   actions :all, except: [:new, :destroy,:show]

   config.filters = false
	
	controller do 
		def action_methods
		 super                                    
		 if current_admin_user.id.to_s == '1'
			super
		  else
			usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
			disallowed = []
			disallowed << 'index' if (!usergroup.has_permission('newsletter_setting_read') && !usergroup.has_permission('newsletter_setting_write') && !usergroup.has_permission('newsletter_setting_delete'))
			disallowed << 'delete' unless (usergroup.has_permission('newsletter_setting_delete'))
			disallowed << 'create' unless (usergroup.has_permission('newsletter_setting_write'))
			disallowed << 'new' unless (usergroup.has_permission('newsletter_setting_write'))
			disallowed << 'edit' unless (usergroup.has_permission('newsletter_setting_write'))
			disallowed << 'destroy' unless (usergroup.has_permission('newsletter_setting_delete'))
			
			super - disallowed
		  end
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
  	# Users List View
  index :download_links => ['csv'] do
     selectable_column
	column 'Email Digest Option' do |feature|
			(feature.email_digest_option == 'M') ? 'Monthly' : (feature.email_digest_option == 'W') ? 'Weekly' : 'Daily' 
	end


    column :created_at
    actions
  end



 form multipart: true do |f|
      f.inputs "Newsletter Setting" do
      f.input :email_digest_option, as: :select, collection: [['Daily','Daily'],['Weekly','Weekly'],['Monthly','Monthly']], include_blank: 'Select Email digest option', label: 'Email digest option'
     

	    f.inputs 'Email Subscription' do
			f.input :job_email, label: 'A daily jobs digest is sent to you of new jobs that are posted on CGMeetup.'
			f.input :gallery_email, label: 'An email is sent to you of new projects that are posted on CGMeetup.'
			f.input :download_email, label: 'An email is sent to you whenever there are new downloads'

			f.input :tutorial_email, label: 'An email is sent to you of new tutorials that are posted on CGMeetup.'
			f.input :news_email, label: 'An email is sent to you of new news that are posted on CGMeetup.'
		end



  	  end


    f.actions
  end

  
end
