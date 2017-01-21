class AddChallengeToGalleries < ActiveRecord::Migration
  def change
	add_column :galleries, :challenge, :string	
  end
end
