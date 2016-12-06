class AddNewFieldToChallenges < ActiveRecord::Migration
  def change
  add_column :challenges, :opening_date, :string
  add_column :challenges, :team_member, :string
  add_column :challenges, :hosts, :string
  end
end
