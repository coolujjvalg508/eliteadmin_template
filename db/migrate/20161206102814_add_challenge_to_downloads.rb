class AddChallengeToDownloads < ActiveRecord::Migration
  def change
	add_column :downloads, :challenge, :string
  end
end
