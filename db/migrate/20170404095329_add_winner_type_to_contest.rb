class AddWinnerTypeToContest < ActiveRecord::Migration
  def change
  	add_column :contests, :winner_type, :integer
  end
end
