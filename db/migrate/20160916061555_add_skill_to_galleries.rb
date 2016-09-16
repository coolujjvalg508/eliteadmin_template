class AddSkillToGalleries < ActiveRecord::Migration
  def change
	add_column :galleries, :skill, :string
  end
end
