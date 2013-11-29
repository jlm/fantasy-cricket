class CreatePlayerScoresTeams < ActiveRecord::Migration
  def change
    create_table :player_scores_teams, :id => false do |t|
      t.references :player_score
      t.references :team
    end

    add_index :player_scores_teams, :player_score_id
    add_index :player_scores_teams, :team_id
  end
end
