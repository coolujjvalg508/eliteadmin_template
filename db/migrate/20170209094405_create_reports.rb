class CreateReports < ActiveRecord::Migration
  def change
    create_table  :reports do |t|
		t.integer :user_id, default: 0
		t.integer :post_id, default: 0
	 	t.string  :post_type
	 	t.text    :report_issue
	 	t.string  :description
     	t.timestamps null: false
    end
  end
end
