ActiveAdmin.register AdminUser do
  menu label: 'Admin User', parent: 'Users'
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

end
