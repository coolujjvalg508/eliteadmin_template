class AddFieldsToJobSkills < ActiveRecord::Migration
  def change
   add_column :job_skills, :description, :text
   add_column :job_skills, :slug, :string
   add_column :job_skills, :parent_id, :integer
   add_column :job_skills, :status, :integer, default: 0
   add_column :job_skills, :image, :string
  end
end
