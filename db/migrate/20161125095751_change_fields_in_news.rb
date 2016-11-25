class ChangeFieldsInNews < ActiveRecord::Migration
  def change
			remove_column :news, :skill_level
			remove_column :news, :language
			remove_column :news, :include_description
			remove_column :news, :total_lecture
			remove_column :news, :sub_title
			remove_column :news, :is_paid
			
			add_column :news, :category_id, :json
			add_column :news, :sub_category_id, :json
  end
end
