json.metadata do
  if @query.errors
    json.message    "There was an error in your query"
    json.errors @query.errors
  else
     json.message    "There was an error, it has been reported"
    if Rails.env.development?
      json.error      @e.inspect
    end
  end
end