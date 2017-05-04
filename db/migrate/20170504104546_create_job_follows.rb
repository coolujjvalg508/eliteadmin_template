class CreateJobFollows < ActiveRecord::Migration
  def change
    create_table :job_follows do |t|
		t.integer :user_id, default: 0
		t.integer :job_id, default: 0
		t.integer :company_id, default: 0
        t.timestamps null: false
    end
  end
end
