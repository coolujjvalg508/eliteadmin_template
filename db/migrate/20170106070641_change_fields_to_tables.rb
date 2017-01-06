class ChangeFieldsToTables < ActiveRecord::Migration
  def change
		add_column :professional_experiences, :professionalexperienceable_id, :integer
		add_column :professional_experiences, :professionalexperienceable_type, :string
		
		add_column :production_experiences, :productionexperienceable_id, :integer
		add_column :production_experiences, :productionexperienceable_type, :string

		add_column :education_experiences, :educationexperienceable_id, :integer
		add_column :education_experiences, :educationexperienceable_type, :string
  end
end
