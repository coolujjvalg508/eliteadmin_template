class ChangeFieldToGalleries < ActiveRecord::Migration
  def change
	remove_column :galleries, :skill
	remove_column :galleries, :software_used
	remove_column :galleries, :subject_matter_id
	
	add_column :galleries, :skill, :json
	add_column :galleries, :software_used, :json
	add_column :galleries, :subject_matter_id, :json
  end
end
