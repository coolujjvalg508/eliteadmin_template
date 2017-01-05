ActiveAdmin.register Message do

	menu label: 'Message',priority: 16
	permit_params :message,:receiver_id,:is_admin
	#actions :all, except: [:new, :update,:edit]
	
	
	 controller do 
		def action_methods
		 super                                    
			if current_admin_user.id.to_s == '1'
			super
		  else
			usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
			disallowed = []
			disallowed << 'index' if (!usergroup.has_permission('message_read') && !usergroup.has_permission('message_write') && !usergroup.has_permission('message_delete'))
			disallowed << 'delete' unless (usergroup.has_permission('message_delete'))
			disallowed << 'create' unless (usergroup.has_permission('message_write'))
			disallowed << 'new' unless (usergroup.has_permission('message_write'))
			disallowed << 'edit' unless (usergroup.has_permission('message_write'))
			disallowed << 'destroy' unless (usergroup.has_permission('message_delete'))
			
			super - disallowed
		  end
		end
	  end
	
	
	controller do
			def create
				params[:message][:is_admin] = true
				super
			end
						
			def update
				super
			end
					
	end
	
	
	
	form multipart: true do |f|
		
		f.inputs "Message" do
			  f.input :receiver_id, as: :select, collection: User.where("id IS NOT NULL ").pluck(:username, :id), :input_html => { :class => "chosen-input" }, include_blank: false, label: 'Reciever',multiple: false
			  f.input :message
		end
		f.actions
    end
  
  filter :sender_id, as: :select, collection: User.where("id IS NOT NULL ").pluck(:username, :id), label: 'Sender Name'
  filter :receiver_id, as: :select, collection: User.where("id IS NOT NULL ").pluck(:username, :id), label: 'Receiver Name'
  filter :created_at
 
	

    	# Users List View
  index :download_links => ['csv'] do
		selectable_column

		column :sender_name do |cat|
			(cat.is_admin) ? 'Admin' : User.find_by(id: cat.sender_id).try(:username)
		end
		column :receiver_name do |cat|
		  User.find_by(id: cat.receiver_id).try(:username)
		end
		column :message do |cat|
		  cat.message.first(50)
		end
		column :created_at
		actions
  end
  
  show do
	attributes_table do
		row :sender_name do |cat|
		 (cat.is_admin) ? 'Admin' : User.find_by(id: cat.sender_id).try(:username)
		end
		row :receiver_name do |cat|
		  User.find_by(id: cat.receiver_id).try(:username)
		end
		row :message do |cat|
		  cat.message
		end
		row :created_at
		
	 end
  end
  
  csv do
		column :sender_name do |cat|
		 (cat.is_admin) ? 'Admin' : User.find_by(id: cat.sender_id).try(:username)
		end
		column :receiver_name do |cat|
		  User.find_by(id: cat.receiver_id).try(:username)
		end
		column :message do |cat|
		  cat.message.first(50)
		end
		column :created_at
		
  end
  
  


end
