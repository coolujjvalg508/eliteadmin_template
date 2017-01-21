class AddFieldsToCategoryTypes < ActiveRecord::Migration
  def change
   add_column :category_types, :description, :text
   add_column :category_types, :slug, :string
   add_column :category_types, :parent_id, :integer
   add_column :category_types, :status, :integer, default: 0
   add_column :category_types, :image, :string
  end
end
