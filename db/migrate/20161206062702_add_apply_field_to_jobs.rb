class AddApplyFieldToJobs < ActiveRecord::Migration
  def change
	 add_column :jobs, :apply_type, :string	
	 add_column :jobs, :apply_instruction, :text	
	 add_column :jobs, :apply_url, :string	
	 add_column :jobs, :apply_email, :string	
  end
end
