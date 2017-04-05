class AddViewCountToChallenges < ActiveRecord::Migration
  def change
 	 	add_column :challenges, :view_count, :integer, :default => 0
  end
end
