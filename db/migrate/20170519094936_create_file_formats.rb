class CreateFileFormats < ActiveRecord::Migration
  def change
    create_table :file_formats do |t|
      t.string   :name	
      t.boolean :status, default: true	
      t.timestamps null: false
    end
  end
end
