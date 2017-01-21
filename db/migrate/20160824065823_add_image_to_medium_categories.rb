class AddImageToMediumCategories < ActiveRecord::Migration
  def change
     add_column :medium_categories, :image, :string
  end
end
