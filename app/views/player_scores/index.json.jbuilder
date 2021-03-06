json.array!(@player_scores) do |player_score|
  json.extract! player_score, :name, :match_id, :innings_id, :bat_minutes, :bat_how, :bat_not_outs, :bat_runs_scored, :bat_balls, :bat_fours, :bat_sixes, :bat_sr, :bowl_overs, :bowl_maidens, :bowl_runs, :bowl_wickets, :bowl_wides, :bowl_noballs, :bowl_er, :field_catches, :field_stumpings, :field_runouts, :field_drops
  json.url player_score_url(player_score, format: :json)
end
