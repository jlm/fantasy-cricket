class AddLastSeasonScoresToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :ls_bat_innings, :integer
    add_column :players, :ls_bat_runs_scored, :integer
    add_column :players, :ls_bat_fours, :integer
    add_column :players, :ls_bat_sixes, :integer
    add_column :players, :ls_bat_fifties, :integer
    add_column :players, :ls_bat_hundreds, :integer
    add_column :players, :ls_bat_ducks, :integer
    add_column :players, :ls_bat_not_outs, :integer
    add_column :players, :ls_bowl_overs, :integer
    add_column :players, :ls_bowl_runs, :integer
    add_column :players, :ls_bowl_wickets, :integer
    add_column :players, :ls_bowl_4_wickets, :integer
    add_column :players, :ls_bowl_6_wickets, :integer
    add_column :players, :ls_bowl_maidens, :integer
    add_column :players, :ls_field_catches, :integer
    add_column :players, :ls_field_runouts, :integer
    add_column :players, :ls_field_stumpings, :integer
    add_column :players, :ls_field_drops, :integer
    add_column :players, :ls_field_mom, :integer
    add_column :players, :ls_bat_score, :integer
    add_column :players, :ls_bowl_score, :integer
    add_column :players, :ls_field_score, :integer
    add_column :players, :ls_bonus, :integer
    add_column :players, :ls_total, :integer
    add_column :players, :ls_bat_avg, :float
    add_column :players, :ls_bowl_avg, :float
    add_column :players, :ls_bat_avg_invalid, :boolean
    add_column :players, :ls_bowl_avg_invalid, :boolean
  end
end
