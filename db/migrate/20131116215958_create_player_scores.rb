class CreatePlayerScores < ActiveRecord::Migration
  def change
    create_table :player_scores do |t|
      t.string :name
      t.integer :match_id
      t.integer :innings_id
      t.integer :bat_minutes
      t.string :bat_how
      t.integer :bat_runs_scored
      t.integer :bat_balls
      t.integer :bat_fours
      t.integer :bat_sixes
      t.decimal :bat_sr
      t.integer :bowl_overs
      t.integer :bowl_maidens
      t.integer :bowl_runs
      t.integer :bowl_wickets
      t.integer :bowl_wides
      t.integer :bowl_noballs
      t.decimal :bowl_er
      t.integer :field_catches
      t.integer :field_stumpings
      t.integer :field_runouts

      t.timestamps
    end
  end
end
