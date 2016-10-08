class AddFieldsToAdvertisement < ActiveRecord::Migration
  def change
    remove_column :advertisements, :image
	add_column :advertisements, :advertisement_package_id, :integer
	add_column :advertisements, :starting_date, :string
	add_column :advertisements, :end_date, :string
	add_column :advertisements, :target_location, :string
	add_column :advertisements, :interest_based, :boolean, :default => false
  end
end
