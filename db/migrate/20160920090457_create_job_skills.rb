class CreateJobSkills < ActiveRecord::Migration
  def change
    create_table :job_skills do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
