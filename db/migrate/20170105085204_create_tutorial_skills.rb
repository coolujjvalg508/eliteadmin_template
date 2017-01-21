class CreateTutorialSkills < ActiveRecord::Migration
  def change
    create_table :tutorial_skills do |t|
	  t.string  :title
      t.timestamps null: false
    end
  end
end
