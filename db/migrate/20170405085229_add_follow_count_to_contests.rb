class AddFollowCountToContests < ActiveRecord::Migration
  def change
  		add_column :contests, :follow_count, :integer, :default => 0
  end
end
