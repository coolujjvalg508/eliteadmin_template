class AddSkillToJobs < ActiveRecord::Migration
  def change
   remove_column :jobs, :skill
   remove_column :jobs, :software_expertise
   remove_column :jobs, :where_to_show
   
   
  # add_column :jobs, :skill, :json
  # add_column :jobs, :software_expertise, :json
  # add_column :jobs, :where_to_show, :json
  end
end
 
