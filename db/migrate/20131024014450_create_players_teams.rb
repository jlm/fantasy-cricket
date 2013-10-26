class CreatePlayersTeams < ActiveRecord::Migration
  def change
    create_table :players_teams, :id => false do |t|
      t.references :team
      t.references :player
    end
    add_index :players_teams, :team_id
    add_index :players_teams, :player_id
  end
end
