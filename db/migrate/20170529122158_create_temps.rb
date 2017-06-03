class CreateTemps < ActiveRecord::Migration
  def change
    create_table :temps do |t|
      t.json  :value	
      t.timestamps null: false
    end
  end
end
