class AddFieldsToProductionExperiences < ActiveRecord::Migration
  def change
   add_column :production_experiences,   :user_id, :integer
   add_column :professional_experiences, :user_id, :integer
   add_column :education_experiences,    :user_id, :integer
  end
end
