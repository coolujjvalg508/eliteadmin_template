class AddSkillToJobs < ActiveRecord::Migration
  def change
   add_column :jobs, :skill, :json
   add_column :jobs, :software_expertise, :json
   add_column :jobs, :where_to_show, :json
  end
end
