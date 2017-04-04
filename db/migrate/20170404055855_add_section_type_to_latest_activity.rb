class AddSectionTypeToLatestActivity < ActiveRecord::Migration
  def change
  	add_column :latest_activities, :section_type, :string
  end
end
