class Addfieldstostaticpages < ActiveRecord::Migration
  def change
  	add_column :static_pages, :meta_tag, :text
  	add_column :static_pages, :meta_description, :text
  end
end
