json.array!(@matches) do |match|
  json.extract! match, :matchname, :date
  json.url match_url(match, format: :json)
end
