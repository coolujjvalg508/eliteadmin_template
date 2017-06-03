ActiveAdmin.register PurchasedProduct , as: "Transactions" do
menu label: 'Transactions'
actions :all, except: [:destroy, :new, :create, :edit, :update]


	index :download_links => ['csv'] do
	     selectable_column
	    
	    column 'User Name' do |cat|
	      User.find_by(id: cat.user_id).try(:firstname)
	    end
	    column 'Product Name' do |down|
	      Download.find_by(id: down.download_id).try(:title)
	    end
	    column 'Product Price($)' do |down|
	      Download.find_by(id: down.download_id).try(:price)
	    end
	    column 'Product Owner' do |down|

	       	if Download.find_by(id: down.download_id).try(:is_admin) == 'N'
	      		User.find_by(id: down.download.user_id).try(:firstname)
	  		else
	  			down = 'Admin'
	  		end
	    end
		column 'Purchased date' do |pur|
			pur.created_at
		end
	    actions
	end
	show do
    	attributes_table do
      		row 'Username' do |cat|
       			User.find_by(id: cat.user_id).try(:firstname)
     		end
      		row 'Product Name' do |cat|
       			Download.find_by(id: cat.download_id).try(:title)
     		end
     		row 'Payment method' do |cat|
       			TransactionHistory.find_by(id: cat.transaction_history_id).try(:payment_method)
     		end
     		row 'Gross Amount($)' do |cat|
       			TransactionHistory.find_by(id: cat.transaction_history_id).try(:gross_amount)
     		end
     		row 'Discount Amount($)' do |cat|
       			TransactionHistory.find_by(id: cat.transaction_history_id).try(:discount_amount)
     		end

     		row 'Net Amount($)' do |cat|
       			TransactionHistory.find_by(id: cat.transaction_history_id).try(:net_amount)
     		end
      		
      		row 'Purchased date' do |pur|
				pur.created_at
			end
    	end
  	end
end
