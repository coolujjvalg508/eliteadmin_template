class AddTeamMemberToGalleries < ActiveRecord::Migration
  def change
  add_column :galleries, :team_member, :string
  end
end
