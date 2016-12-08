class AddPacakgeFieldsToJobs < ActiveRecord::Migration
  def change
	add_column :jobs, :is_urgent, :boolean, :default => false
  end
end
