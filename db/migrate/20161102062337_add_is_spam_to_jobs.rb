class AddIsSpamToJobs < ActiveRecord::Migration
  def change
   add_column :jobs, :is_spam, :boolean, :default => false
  end
end
