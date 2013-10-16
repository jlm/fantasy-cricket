json.array!(@players) do |player|
  json.extract! player, :name, :age_category
  json.url player_url(player, format: :json)
end
