class KillFieldToJobs < ActiveRecord::Migration
  def change
   remove_column :jobs, :skill
   remove_column :jobs, :software_expertise
   remove_column :jobs, :where_to_show
  end
end
