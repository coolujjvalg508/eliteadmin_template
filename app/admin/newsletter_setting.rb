ActiveAdmin.register NewsletterSetting do

menu label: 'Newsletter Setting'
	permit_params :email_digest_option, :en_someone_like,:en_someone_comment,:en_someone_follow,:en_im_following_post,:en_someone_comment_on_i_commented, :osn_someone_like,:osn_someone_comment,:osn_someone_follow,:osn_im_following_post,:osn_someone_comment_on_i_commented

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
     

	     f.inputs 'Email Notification on my artwork and portfolio' do
			  f.input :en_someone_like, label: 'When someone likes my artwork'
		      f.input :en_someone_comment, label: 'When someone comments on my artwork'
		      f.input :en_someone_follow, label: 'When someone follows me'
		      f.input :en_im_following_post, label: 'When a user i\'m following posts new artwork'
		      f.input :en_someone_comment_on_i_commented, label: 'When someone comments on artwork i\'ve commented on'
		 
	  	  end

	  	  f.inputs 'On Site Notification on my artwork and portfolio' do
			  f.input :osn_someone_like, label: 'When someone likes my artwork'
		      f.input :osn_someone_comment, label: 'When someone comments on my artwork'
		      f.input :osn_someone_follow, label: 'When someone follows me'
		      f.input :osn_im_following_post, label: 'When a user i\'m following posts new artwork'
		      f.input :osn_someone_comment_on_i_commented, label: 'When someone comments on artwork i\'ve commented on'
		 
	  	  end

  	  end


    f.actions
  end

  
end
