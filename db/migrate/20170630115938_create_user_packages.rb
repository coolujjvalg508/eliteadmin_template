class CreateUserPackages < ActiveRecord::Migration
  def change
    create_table :user_packages do |t|
      t.string :title
      t.text :description
      t.integer :amount
      t.string :image
      t.integer :duration
      t.string :duration_unit

      t.timestamps null: false
    end
  end
end
