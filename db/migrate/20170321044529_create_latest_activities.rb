class CreateLatestActivities < ActiveRecord::Migration
  def change
    create_table :latest_activities do |t|
      t.integer  :user_id
      t.integer  :post_id
      t.integer  :artist_id
      t.string   :activity_type
      t.timestamps null: false
    end
  end
end
