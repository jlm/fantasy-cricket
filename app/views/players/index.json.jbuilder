json.array!(@players) do |player|
  json.extract! player, :name, :age_category, :player_category, :price, :bat_innings, :bat_runs_scored, :bat_fifties, :bat_hundreds, :bat_ducks, :bat_not_outs, :bowl_overs, :bowl_runs, :bowl_wickets, :bowl_4_wickets, :bowl_6_wickets, :field_catches, :field_runouts, :field_stumpings, :field_drops, :field_mom, :team
  json.url player_url(player, format: :json)
end
