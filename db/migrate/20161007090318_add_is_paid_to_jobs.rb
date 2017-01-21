class AddIsPaidToJobs < ActiveRecord::Migration
  def change
  add_column :jobs, :is_paid, :boolean, :default => true
  end
end
