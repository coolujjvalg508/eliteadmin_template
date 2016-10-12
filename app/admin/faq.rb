ActiveAdmin.register Faq do
 
 menu label: 'Faq', parent: 'Pages',priority: 2
 config.sort_order = 'position_asc'
 permit_params :question, :answer, :active, :bootsy_image_gallery_id

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


 controller do 
	def action_methods
	 super                                    
		if current_admin_user.id.to_s == '1'
		super
	  else
		usergroup = UserGroup.where(:id => current_admin_user.group_id.to_s).first
		disallowed = []
		disallowed << 'index' if (!usergroup.has_permission('faq_read') && !usergroup.has_permission('faq_write') && !usergroup.has_permission('faq_delete'))
		disallowed << 'delete' unless (usergroup.has_permission('faq_delete'))
		disallowed << 'create' unless (usergroup.has_permission('faq_write'))
		disallowed << 'new' unless (usergroup.has_permission('faq_write'))
		disallowed << 'edit' unless (usergroup.has_permission('faq_write'))
		disallowed << 'destroy' unless (usergroup.has_permission('faq_delete'))
		
		super - disallowed
	  end
	end
  end



	 # New/Edit Form
  form :title => 'New FAQ' do |f|
    f.inputs "FAQ" do
      f.input :question, :rows => 15, :cols => 15
      li do
        insert_tag(Arbre::HTML::Label, "Answer", class: "label") { content_tag(:abbr, "*", title: "required") }
        f.bootsy_area :answer, :rows => 15, :cols => 15, editor_options: { html: true }
      end
      f.input :active
    end
    f.actions
  end  
  
   # Index Page
  index :download_links => ['csv'], :title => "FAQs" do
    selectable_column
    column 'Question' do |faq|
      tr_con = faq.question.first(50)
      link_to tr_con.html_safe, admin_faq_path(faq)
    end
    column 'Answer' do |faq|
      tr_con = faq.answer.first(50)
      tr_con.html_safe
    end
    column "Status" do |status|
      status.try(:active) ? 'Active' : 'Inactive'
    end
    column :created_at
    actions
  end
  
   csv do
		column :question
		column :answer
		column :active
		column :created_at
	end
  
  
  
    # Filters
  filter :question
  filter :answer
  filter :active, as: :select, collection: [['Active',1], ['Inactive', 0]], label: "Status"
  filter :created_at
  
    # Show Page
  show :title => 'FAQ' do 
    attributes_table do
      row 'Question' do |faq|
        text_node faq.question.html_safe
      end
      row 'Answer' do |faq|
        text_node faq.answer.html_safe
      end      
      row :active
      row :created_at
    end
  end

end
