class ChangeFieldsToJobs < ActiveRecord::Migration
  def change
   add_column :jobs, :show_on_cgmeetup, :boolean
   add_column :jobs, :show_on_website, :boolean
  end
end
