class ChangeFieldsToGalleries < ActiveRecord::Migration
  def change
   add_column :galleries, :show_on_cgmeetup, :boolean
   add_column :galleries, :show_on_website, :boolean
  end
end
