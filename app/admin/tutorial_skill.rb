ActiveAdmin.register TutorialSkill do
  config.sort_order = 'created_at_asc'

  menu label: 'Skill', parent: 'Tutorial',priority: 3

  permit_params :title

  controller do
    def action_methods
      super
      if current_admin_user.role == 'super_admin'
        super
      else
        disallowed = []
        disallowed << 'index' if (!current_admin_user.has_permission('tutorial_skill_read') && !current_admin_user.has_permission('tutorial_skill_write') && !current_admin_user.has_permission('tutorial_skill_delete'))
        disallowed << 'delete' unless (current_admin_user.has_permission('tutorial_skill_delete'))
        disallowed << 'create' unless (current_admin_user.has_permission('tutorial_skill_write'))
        disallowed << 'new' unless (current_admin_user.has_permission('tutorial_skill_write'))
        disallowed << 'edit' unless (current_admin_user.has_permission('tutorial_skill_write'))
        disallowed << 'destroy' unless (current_admin_user.has_permission('tutorial_skill_delete'))
        super - disallowed
      end
    end
  end

  # Index Page
	index :download_links => ['csv'] do
    selectable_column
    column "Title" do |sys_email|
      sys_email.title
    end
    column :created_at
    actions
  end

  csv do
    column :title
 	column :created_at
  end

  # New/Edit Form
  form do |f|
    f.inputs "Tutorial Skill" do
    	f.input :title
    end
    f.actions
  end

  # Filters
  filter :title
  filter :created_at

  # Show Page
  show :title => proc{|sys_email| truncate(sys_email.title, length: 50) } do
    attributes_table do

      row :title
    
      row :created_at
    end
  end


end
