class ChangeFieldToJobs < ActiveRecord::Migration
  def change
			remove_column :jobs, :is_paid
			remove_column :jobs, :package_id
			
			add_column :jobs, :company_url, :string
			add_column :jobs, :state, :string
			add_column :jobs, :package_id, :json
			
			
  end
end
