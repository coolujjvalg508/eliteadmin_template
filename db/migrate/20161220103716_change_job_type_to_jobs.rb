class ChangeJobTypeToJobs < ActiveRecord::Migration
  def change
  	change_column :jobs, :job_type, :string
  end
end
