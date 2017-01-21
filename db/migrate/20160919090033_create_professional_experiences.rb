class CreateProfessionalExperiences < ActiveRecord::Migration
  def change
    create_table :professional_experiences do |t|
      t.string :company_name
      t.string :title
      t.string :location
      t.text   :description
      t.string :from_month
      t.string :from_year
      t.string :to_month
      t.string :to_year
      t.string :currently_worked
	  t.timestamps null: false
    end
  end
end
