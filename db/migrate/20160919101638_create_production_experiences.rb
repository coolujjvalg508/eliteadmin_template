class CreateProductionExperiences < ActiveRecord::Migration
  def change
    create_table :production_experiences do |t|
      t.string :production_title
      t.string :release_year
      t.string :production_type
      t.string :your_role
      t.string :company


      t.timestamps null: false
    end
  end
end
