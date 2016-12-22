class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name
      t.string :code, limit: 3
      t.integer :status, default: 1

      t.timestamps null: false
    end
  end
end
