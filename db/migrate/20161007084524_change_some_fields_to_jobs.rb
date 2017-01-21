class ChangeSomeFieldsToJobs < ActiveRecord::Migration
  def change
   remove_column :jobs, :work_remotely
   remove_column :jobs, :relocation_asistance
   remove_column :jobs, :use_tag_from_previous_upload
   remove_column :jobs, :is_featured 	
   
   add_column :jobs, :work_remotely, :boolean, :default => false
   add_column :jobs, :relocation_asistance, :boolean, :default => false
   add_column :jobs, :use_tag_from_previous_upload, :boolean, :default => false
   add_column :jobs, :is_featured, :boolean, :default => false
  end
end
