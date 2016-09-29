ActiveAdmin.register JobCategory , as: "Position" do
  
  menu label: 'Position', parent: 'User Setting',priority: 2
  permit_params :name

  form multipart: true do |f|
		
		f.inputs "Job Type Category" do
		  f.input :name
		end
		
		f.actions
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
