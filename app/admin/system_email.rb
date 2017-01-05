ActiveAdmin.register SystemEmail do

  config.sort_order = 'created_at_asc'

  menu label: 'System Emails', parent: 'Settings',priority: 2

  permit_params :title,:subject,:content, :active

  actions :all, except: [:new, :destroy]

  action_item :back, only: :show do
    link_to "Back", admin_system_emails_path, method: :get
  end

  controller do
    def action_methods
      super
      if current_admin_user.role == 'super_admin'
        super
      else
        disallowed = []
        disallowed << 'index' if (!current_admin_user.has_permission('systememail_read') && !current_admin_user.has_permission('systememail_write') && !current_admin_user.has_permission('systememail_delete'))
        disallowed << 'delete' unless (current_admin_user.has_permission('systememail_delete'))
        disallowed << 'create' unless (current_admin_user.has_permission('systememail_write'))
        disallowed << 'new' unless (current_admin_user.has_permission('systememail_write'))
        disallowed << 'edit' unless (current_admin_user.has_permission('systememail_write'))
        disallowed << 'destroy' unless (current_admin_user.has_permission('systememail_delete'))
        super - disallowed
      end
    end
  end

  # Index Page
	index :download_links => ['csv'] do
    selectable_column
    column "S.No" do |sys_email|
      sys_email.identifier
    end
    column "Title" do |sys_email|
      link_to sys_email.title, admin_system_email_path(sys_email)
    end
    column :subject
    column 'Content' do |email|
      tr_con = email.content.first(200)
      text_node tr_con.html_safe
    end
    column :status
    actions
  end

  csv do
    column :title
    column :subject
    column 'Content' do |email|      
      tr_con = email.content.first(200)
      strip_tags(tr_con)
    end    
    column :status
  end

  # New/Edit Form
  form do |f|
    f.inputs "Static Page" do
    	f.input :title, :input_html => { :disabled => true }
    	f.input :subject
      div do
      f.input :content,  :input_html => { :class => "tinymce" }, :rows => 40, :cols => 50 ,label: false
      end
      
      # f.input :footer, :as => :ckeditor
      f.input :status
    end
    f.actions
  end

  # Filters
  filter :title
  filter :subject
  filter :content
  filter :status, as: :select, collection: [['Active',1], ['InActive', 0]]
  filter :created_at

  # Show Page
  show :title => proc{|sys_email| truncate(sys_email.title, length: 50) } do
    attributes_table do
      row "S.no" do |email|
        email.identifier
      end
      row :title
      row :subject
      row 'Content' do |email|
        text_node email.content.html_safe
      end
      row :status
      row :created_at
    end
  end

  batch_action "Update 'Status' for", form: { status: [['Active',1],['Inactive',0]] } do |ids, inputs|
    SystemEmail.where(id: ids).update_all(status: inputs[:status])
    redirect_to collection_path, notice: "Status updated successfully"
  end

end
