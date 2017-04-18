class AddParamlinkToUserAndChallenges < ActiveRecord::Migration
  def change
  	add_column :challenges, :paramlink, :string
  end
end
