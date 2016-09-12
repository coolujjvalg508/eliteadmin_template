class AddScheduleTimeToGalleries < ActiveRecord::Migration
  def change
	add_column :galleries, :schedule_time, :string
  end
end
