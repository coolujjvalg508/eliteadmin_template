class CreateAddLatlongToJobs < ActiveRecord::Migration
  def change
    create_table :add_latlong_to_jobs do |t|
		add_column :jobs, :latitude, :string
	  	add_column :jobs, :longitude, :string
      t.timestamps null: false
    end
  end
end
