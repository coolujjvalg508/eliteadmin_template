class ChangeFieldsInDownloads < ActiveRecord::Migration
	  def change
			add_column :downloads, :post_type_category_id, :json
			add_column :downloads, :sub_category_id, :json
			add_column :downloads, :changelog, :text
			add_column :downloads, :free, :boolean, :default => false
			add_column :downloads, :is_feature, :boolean, :default => false
			
			remove_column :downloads, :skill_level
			remove_column :downloads, :language
			remove_column :downloads, :include_description
			remove_column :downloads, :total_lecture
			remove_column :downloads, :sub_title
			remove_column :downloads, :user_title
	  end
end
