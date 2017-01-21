class AddFieldsInPostTypes < ActiveRecord::Migration
  def change
	 add_column :post_types, :image, :string	
	 add_column :post_types, :description, :text	
	 add_column :post_types, :slug, :string	
	
	 add_column :post_types, :parent_id, :integer	
	 add_column :post_types, :status, :integer, default: 0	
		
  end
end
