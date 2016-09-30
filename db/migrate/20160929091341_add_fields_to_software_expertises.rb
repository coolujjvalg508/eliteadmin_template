class AddFieldsToSoftwareExpertises < ActiveRecord::Migration
  def change
   add_column :software_expertises, :description, :text
   add_column :software_expertises, :slug, :string
   add_column :software_expertises, :parent_id, :integer
   add_column :software_expertises, :status, :integer, default: 0
   add_column :software_expertises, :image, :string
  end
end
