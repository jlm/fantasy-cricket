json.array!(@tokens) do |token|
  json.extract! token, :realname, :email, :ticketno, :tokenstr, :user_id
  json.url token_url(token, format: :json)
end
