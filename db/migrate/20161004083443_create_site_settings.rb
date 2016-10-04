class CreateSiteSettings < ActiveRecord::Migration
  def change
    create_table :site_settings do |t|
	  t.string :site_title
	  t.string :site_email
	  t.string :site_phone
	  t.string :copyright_text
	  t.string :no_of_image
	  t.string :no_of_video
	  t.string :no_of_marmoset
	  t.string :no_of_sketchfeb
      t.timestamps null: false
    end
  end
end
