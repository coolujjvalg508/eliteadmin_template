ActiveAdmin.register Category do

    menu label: 'Category'
	permit_params :name, :parent_id, :description, :slug


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

 form multipart: true do |f|
      f.inputs "Category" do
      f.input :parent_id, as: :select, collection: Category.where("parent_id IS NULL").pluck(:name, :id), include_blank: 'Select Parent'
      #f.input :parent_id, :as => :select
      f.input :name
      f.input :description
      f.input :slug
    end

    f.actions
  end



end
