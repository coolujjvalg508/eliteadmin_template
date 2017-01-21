class AddPackageIdToJobs < ActiveRecord::Migration
  def change
  add_column :jobs, :package_id, :integer
  end
end
