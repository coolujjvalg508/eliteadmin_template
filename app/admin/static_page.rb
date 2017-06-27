ActiveAdmin.register StaticPage do
 
    menu label: 'Static Pages', parent: 'Pages'
	permit_params :title, :description, :page_url
	config.sort_order = 'updated_at_desc'
   # actions :all, except: [:new, :destroy]
    
    
    controller do 
		def action_methods
		 super                                    
			if current_admin_user.id.to_s == '1'
			super
		  else
			usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
			disallowed = []
			disallowed << 'index' if (!usergroup.has_permission('staticpage_read') && !usergroup.has_permission('staticpage_write') && !usergroup.has_permission('staticpage_delete'))
			disallowed << 'delete' unless (usergroup.has_permission('staticpage_delete'))
			disallowed << 'create' unless (usergroup.has_permission('staticpage_write'))
			disallowed << 'new' unless (usergroup.has_permission('staticpage_write'))
			disallowed << 'edit' unless (usergroup.has_permission('staticpage_write'))
			disallowed << 'destroy' unless (usergroup.has_permission('staticpage_delete'))
			
			super - disallowed
		  end
		end
	  end
    
    
  index :download_links => ['csv'] do
     selectable_column
    
    column :title
    column "Paramlink", :page_url
    column 'Description' do |cms|
      tr_con = cms.description.first(50)
      tr_con.html_safe
    end    
    column :meta_tag
    column :meta_description
    column :created_at
    actions
  end   
    
    
    
    # New/Edit Form
  form do |f|
    f.inputs "Static Page" do
    	f.input :title
        f.input :page_url, :label => 'Paramlink', :as => :string
        f.input :meta_tag, :label => 'Meta Tag', as: :text
        f.input :meta_description, :label => 'Meta Description', as: :text
     # f.input :page_url, :label => 'Page Url', :as => :string
     / li do
       insert_tag(Arbre::HTML::Label, "Content", class: "label") { content_tag(:abbr, "*", title: "required") }
        f.bootsy_area :description, :rows => 25, :cols => 25, editor_options: { html: true }
      end /
      
        div do
			f.input :description,  :input_html => { :class => "tinymce" }, :rows => 40, :cols => 50 ,label: false
		  end

    end
    f.actions
  end
  
  
  filter :title, :as => :string
  filter :page_url, :as => :string


    show do
      attributes_table do
        row :title    
        row "Paramlink",:page_url        
        row :meta_tag
        row :meta_description
        row :description
        row :created_at
        row :updated_at
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
