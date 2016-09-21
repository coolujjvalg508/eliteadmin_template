class CreateEducationExperiences < ActiveRecord::Migration
  def change
    create_table :education_experiences do |t|
      t.string :school_name
	  t.string :field_of_study
      t.string :month_val
      t.string :year_val
      t.text   :description
      t.timestamps null: false

    end
  end
end
