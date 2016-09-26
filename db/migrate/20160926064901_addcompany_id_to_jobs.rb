class AddcompanyIdToJobs < ActiveRecord::Migration
  def change
	add_column :jobs, :company_id, :integer
  end
end
