class AddIsSubmittedToChallenges < ActiveRecord::Migration
  def change
  	 add_column :challenges, :is_submitted, :integer, :default => 0
  end
end
