class CreateTeamMembershipJoinTable < ActiveRecord::Migration[7.2]
  def change
    create_join_table :users, :teams, table_name: "team_memberships" do |t|
      t.index [ :user_id, :team_id ]
      t.index [ :team_id, :user_id ]
    end
  end
end
