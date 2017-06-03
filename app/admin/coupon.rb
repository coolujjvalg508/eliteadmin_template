ActiveAdmin.register Coupon do


	menu label: 'Manage Coupons',priority: 5
	permit_params :coupon_code, :discount_value, :discount_type, :valid_from, :valid_till, :status, :no_of_use, :user_id, :is_admin

	filter :coupon_code
  	filter :discount_value
  	filter :valid_from
  	filter :valid_till
  	filter :status, as: :select, collection: [['Active',1], ['Inactive', 0]], label: 'Status'



  	controller do
	    def create
			params[:coupon][:user_id] = current_admin_user.id.to_s
			params[:coupon][:is_admin] = 'Y'
			super
		end	
    end




	index do
	    selectable_column
	    
	    column :coupon_code
	    column :discount_value
	    column :discount_type
	    column :valid_from
	    column :valid_till
	    column "Status" do |ee|
	      (ee.status == true) ? "Active" : "Inactive"
	    end
	    column :created_at
	    actions
	end

	form multipart: true do |f|

	    f.inputs "Coupon Details" do
	      f.input :coupon_code
	      f.input :discount_value
	      f.input :discount_type, as: :select, collection: Coupon::DISCOUNT_TYPE, include_blank: 'Select Discount Type'
	      f.input :valid_from, include_blank: false
	      f.input :valid_till, include_blank: false
	      f.input :no_of_use, label: 'No. of time usable'
	      f.input :status, label: 'Is Active'
	    end
	    f.actions
  	end

  	show do
	    attributes_table do
	      row :coupon_code
	      row :discount_value
	      row :discount_type
	      row :valid_from
	      row :valid_till
	      row :no_of_use
	      row "Status" do |ee|
	        (ee.status == true) ? "Active" : "Inactive"
	      end
	      row :created_at
	      row :updated_at
	    end
  	end

end