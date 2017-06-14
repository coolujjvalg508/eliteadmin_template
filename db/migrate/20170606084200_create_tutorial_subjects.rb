class CreateTutorialSubjects < ActiveRecord::Migration
  def change
    create_table :tutorial_subjects do |t|
 	 t.integer :topic_id
	 t.string :name
	 t.string :image
      t.text :description
      t.string :slug
      t.integer :parent_id, index: true
      t.integer :status, default: 0
	
      t.timestamps null: false
    end
  end
end
