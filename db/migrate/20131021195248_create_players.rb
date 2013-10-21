class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :age_category
      t.integer :bat_innings
      t.integer :bat_runs_scored
      t.integer :bat_fifties
      t.integer :bat_hundreds
      t.integer :bat_ducks
      t.integer :bat_not_outs
      t.integer :bowl_overs
      t.integer :bowl_runs
      t.integer :bowl_wickets
      t.integer :bowl_4_wickets
      t.integer :bowl_6_wickets
      t.integer :field_catches
      t.integer :field_runouts
      t.integer :field_stumpings
      t.integer :field_drops
      t.integer :field_mom

      t.timestamps
    end
  end
end
