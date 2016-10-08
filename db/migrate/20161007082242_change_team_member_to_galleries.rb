class ChangeTeamMemberToGalleries < ActiveRecord::Migration
  def change
  remove_column :galleries, :team_member
  add_column :galleries, :team_member, :json
  end
end
