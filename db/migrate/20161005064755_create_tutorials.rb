class CreateTutorials < ActiveRecord::Migration
  def change
    create_table :tutorials do |t|
	  t.string  :title
	  t.string  :paramlink
      t.text    :description
      t.integer :media_type, default: 0
      t.string  :image
      t.string  :video
      t.string  :uploaded_by
      t.boolean  :status, default: true

      t.timestamps null: false
    end
  end
end
