class AddIsApprovedToJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :is_approved, :boolean, :default => true
  end
end
