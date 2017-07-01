class Addwidgetfieldstojob < ActiveRecord::Migration
  def change

	add_column :widgets, :show_on_jobs_map_page, :boolean
	add_column :widgets, :show_on_companies_map_page, :boolean
  end
end
