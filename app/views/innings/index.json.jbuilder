json.array!(@innings) do |innings|
  json.extract! innings, :matchname, :date, :inningsname, :innings_id
  json.url innings_url(innings, format: :json)
end
