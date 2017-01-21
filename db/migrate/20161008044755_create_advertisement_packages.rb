class CreateAdvertisementPackages < ActiveRecord::Migration
  def change
    create_table :advertisement_packages do |t|
	  t.string  :title
      t.text    :description
      t.string  :amount
      t.string  :image    
      t.timestamps null: false
    end
  end
end
