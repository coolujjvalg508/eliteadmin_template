class AddLocationToGalleries < ActiveRecord::Migration
  def change
  add_column :galleries, :location, :string
  end
end
