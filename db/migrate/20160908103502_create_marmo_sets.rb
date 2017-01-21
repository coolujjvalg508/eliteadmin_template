class CreateMarmoSets < ActiveRecord::Migration
  def change
    create_table :marmo_sets do |t|
        t.string :marmoset
        t.integer :marmosetable_id, null: false, index: true
		t.string :marmosetable_type, null: false, index: true
		t.timestamps null: false
    end
  end
end
