class AddChallengeToTutorials < ActiveRecord::Migration
  def change
	add_column :tutorials, :challenge, :string
  end
end
