class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
	  t.string  :title
      t.text    :description
      t.integer :media_type, default: 0
      t.string  :image
      t.string  :video
      t.string  :uploaded_by
      t.timestamps null: false
    end
  end
end
