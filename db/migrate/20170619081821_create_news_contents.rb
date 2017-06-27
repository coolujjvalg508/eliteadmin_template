class CreateNewsContents < ActiveRecord::Migration
  def change
    create_table :news_contents do |t|
	  t.string  :title
      t.integer  :news_id
      t.timestamps null: false
    end
  end
end
