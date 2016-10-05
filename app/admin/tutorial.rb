ActiveAdmin.register Tutorial do

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

menu label: 'Tutorial'
	permit_params :title,:paramlink,:description,:media_type,:image,:video,:uploaded_by,:status
 
	form multipart: true do |f|
			
			f.inputs "Tutorial" do
			  f.input :title
			  f.input :paramlink,label:'Permalink'
			  li do
				insert_tag(Arbre::HTML::Label, "Description", class: "label") { content_tag(:abbr, "*", title: "required") }
				f.bootsy_area :description, :rows => 15, :cols => 15, editor_options: { html: true }
			  end
			 
			  f.input :media_type, as: :select, collection: [['Image',1],['Video',0]], include_blank: false
			  f.input :image, label:'Image'
			  f.input :video, label:'Video'
			  f.input :uploaded_by,label:'Uploaded By'
			  f.input :status,label:'Status'
		  end
			
			
		f.actions
	  end


	  filter :title
	  filter :status, as: :select, collection: [['Active',true], ['Inactive', false]], label: 'Status'
	  filter :created_at

	 # Users List View
	  index :download_links => ['csv'] do
		   selectable_column
			column 'Image' do |img|
				image_tag img.try(:image).try(:url, :thumb), height: 50, width: 50
		   end
		   column 'title' 
		   column 'Description' do |description|
			  tr_con = description.description.first(45)
		   end
		   column 'Uploaded By' do |ub|
			  ub.uploaded_by
		   end
		   column 'Status' do |user|
			  user.status? ? 'Active' : 'Inactive'
		   end
		   actions
	  end


   show do
		attributes_table do
			  row :title
			  row :paramlink
			  row :description
			  row :uploaded_by
			  row :Image do |cat|
				unless !cat.image.present?
				  image_tag(cat.try(:image).try(:url, :event_small))
				else
				  image_tag('/assets/default-blog.png', height: '50', width: '50')
				end
			  end
			   row 'Video' do
					ul class: "image-blk" do
						if tutorial.video.present?
							raw('<iframe title="Video" width="300" height="200" src="'+tutorial.video.url+'" frameborder="0" allowfullscreen></iframe>')
						end
					end
		 end
		  
		  row :created_at
		end
    end
    
    
    
    csv do
		column :title
		column :paramlink
		column :description
		column :created_at
		
    end





end
