ActiveAdmin.register StaticPage do
 
    menu label: 'CMS'
	permit_params :title, :description, :page_url
	config.sort_order = 'updated_at_desc'
   # actions :all, except: [:new, :destroy]
    
    
  index :download_links => ['csv'] do
     selectable_column
    
    column :title
    column :page_url
  
    column 'Description' do |cms|
      tr_con = cms.description.first(50)
      tr_con.html_safe
    end
	column :created_at
    actions
  end   
    
    
    
    # New/Edit Form
  form do |f|
    f.inputs "Static Page" do
    	f.input :title
      f.input :page_url, :label => 'Page Url', :as => :string, :input_html => { :disabled => true } 
      li do
        insert_tag(Arbre::HTML::Label, "Content") { content_tag(:abbr, "*", title: "required") }
        f.bootsy_area :description, :rows => 25, :cols => 25, editor_options: { html: true }
      end
    end
    f.actions
  end
  
  
  filter :title, :as => :string
  filter :page_url, :as => :string
 
   
    

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
