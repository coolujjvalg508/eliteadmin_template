class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string  :title
      t.string  :image
      t.integer  :tutorial_id
      t.timestamps null: false
    end
  end
end
