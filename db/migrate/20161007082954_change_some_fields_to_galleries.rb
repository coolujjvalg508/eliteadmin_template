class ChangeSomeFieldsToGalleries < ActiveRecord::Migration
  def change
   remove_column :galleries, :use_tag_from_previous_upload
   remove_column :galleries, :has_adult_content
   remove_column :galleries, :is_featured
   
   add_column :galleries, :use_tag_from_previous_upload, :boolean, :default => false
   add_column :galleries, :has_adult_content, :boolean, :default => false
   add_column :galleries, :is_featured, :boolean, :default => false
  end
end
