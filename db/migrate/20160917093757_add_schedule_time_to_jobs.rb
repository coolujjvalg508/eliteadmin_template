class AddScheduleTimeToJobs < ActiveRecord::Migration
  def change
  add_column :jobs, :schedule_time, :string
  end
end
