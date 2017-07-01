class Addjoblistfieldstowidgets < ActiveRecord::Migration
  def change
  	add_column :widgets, :show_on_jobs_list_page, :boolean
	  add_column :widgets, :show_on_companies_list_page, :boolean
  end
end
