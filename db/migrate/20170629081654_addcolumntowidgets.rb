class Addcolumntowidgets < ActiveRecord::Migration
	def change
	  	change_table :widgets do |t|
			t.boolean :show_on_home_page, :show_on_news_page, :show_on_downloads_page, :show_on_tutorials_page, :show_on_jobs_page
			t.rename :sectionname, :section_name
			t.rename :widgetcode, :ad_code
			t.remove :status, :sort_order
		end
	end
end
