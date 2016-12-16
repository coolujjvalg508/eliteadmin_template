class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
	  t.string  :title
	  t.string  :sectionname
	  t.text    :widgetcode
	  t.string  :position
	  t.integer :status, default: 1
	  t.integer :sort_order, default: 0
      t.timestamps null: false
    end
  end
end
