class CreateQuestionaires < ActiveRecord::Migration
  def change
    create_table :questionaires do |t|
		t.string :question
		t.text :answer
      t.timestamps null: false
    end
  end
end
