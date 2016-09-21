class CreateSoftwareExpertises < ActiveRecord::Migration
  def change
    create_table :software_expertises do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
