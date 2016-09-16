class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :title
      t.text :tags
      t.integer :status, default: 1

      t.timestamps null: false
    end
  end
end
