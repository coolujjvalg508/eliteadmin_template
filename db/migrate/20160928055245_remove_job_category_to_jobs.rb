class RemoveJobCategoryToJobs < ActiveRecord::Migration
  def change
  remove_column :jobs, :job_category
  end
end
