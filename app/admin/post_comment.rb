ActiveAdmin.register PostComment do

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
	menu false
	#menu label: 'Comments'
	permit_params :title,:description,:is_pending,:is_approve,:is_spam,:is_trash
	actions :all, except: [:new, :create]
	
	form multipart: true do |f|
		
		f.inputs "Comment" do
			  f.input :title
			  f.input :description,label:'Description'
			  f.input :is_pending , as: :boolean,label: "Make Pending"
			  f.input :is_approve , as: :boolean,label: "Make Approve"
			  f.input :is_spam , as: :boolean,label: "Make Spam"
			  f.input :is_trash , as: :boolean,label: "Make Trash"
		
		end
		
		
	f.actions
  end
  
  	controller do 
		def action_methods
		 super                                    
			if current_admin_user.id.to_s == '1'
			super
		  else
			usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
			disallowed = []
			disallowed << 'index' if (!usergroup.has_permission('comment_read') && !usergroup.has_permission('comment_write') && !usergroup.has_permission('comment_delete'))
			disallowed << 'delete' unless (usergroup.has_permission('comment_delete'))
			disallowed << 'create' unless (usergroup.has_permission('comment_write'))
			disallowed << 'new' unless (usergroup.has_permission('comment_write'))
			disallowed << 'edit' unless (usergroup.has_permission('comment_write'))
			disallowed << 'destroy' unless (usergroup.has_permission('comment_delete'))
			
			super - disallowed
		  end
		end
  end
  
  
  
  
  filter :title
  filter :is_pending, as: :select, collection: [['Yes',1], ['No', 0]], label: 'Pending Comments'
  filter :is_approve, as: :select, collection: [['Yes',1], ['No', 0]], label: 'Approved Comments'
  filter :is_spam, as: :select, collection: [['Yes',1], ['No', 0]], label: 'Spam Comments'
  filter :is_trash, as: :select, collection: [['Yes',1], ['No', 0]], label: 'Trash Comments'
  filter :created_at


	# Users List View
  index :download_links => ['csv'] do
	   selectable_column
	   column 'Username' do |uname|
			User.find_by(id: uname.user_id).try(:firstname)
		end
	   column 'Title' do |feature|
			feature.title
	   end
	   column 'Comment' do |feature|
			tr_con = feature.description.first(50)
			tr_con.html_safe

	   end
	    column 'Is Pending' do |feature|
			feature.is_pending
		end
		 column 'Is Approve' do |feature|
			feature.is_approve
		end
		 column 'Is spam' do |feature|
			feature.is_spam
		end
		 column 'Is Trash' do |feature|
			feature.is_trash
		end

	  actions
  end
    
	
    


end
