class AddViewCountToGalleries < ActiveRecord::Migration
  def change
  	  	add_column :galleries, :view_count, :integer, :default => 0
  end
end
