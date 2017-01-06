ActiveAdmin.register AdminUser do
  menu label: 'Admin User', parent: 'Account', priority: 2
  permit_params :email, :password, :password_confirmation,:group_id
  





  
  
 
 index :download_links => ['csv'] do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
 
	actions
    
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :group_id, as: :select, collection:  UserGroup.where("name != '' ").pluck(:name, :id),label:'Select Group',include_blank:'Select Group'	
    end
    f.actions
    
  end
  
   show do
		attributes_table do
		  row :email
		  row :Encrypted_Password do |rp|
		    rp.encrypted_password
		  end
		  row :Reset_Password_Token do |rp|
		    rp.reset_password_token
		  end
		  row :Reset_Password_Sent_At do |rp|
		    rp.reset_password_sent_at
		  end
		  
		  row :Remember_Created_At do |rp|
		    rp.remember_created_at
		  end
		  
		  row :sign_in_count do |rp|
		    rp.sign_in_count
		  end
		 
		  row :current_sign_in_at do |rp|
		    rp.current_sign_in_at
		  end
		   row :last_sign_in_at do |rp|
		    rp.last_sign_in_at
		  end
		   row :current_sign_in_ip do |rp|
		    rp.current_sign_in_ip
		  end
		   row :last_sign_in_ip do |rp|
		    rp.last_sign_in_ip
		  end
		 
		  row :group_id do |rp|
				UserGroup.find_by(id: rp.group_id).try(:name)
		  end

		  row :created_at
		end
    end
  

end
