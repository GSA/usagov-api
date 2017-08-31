json.metadata do
  json.message    "there was an issue, this is for debugging purposes, it has been reported"


  if Rails.env.development?
    json.error      @e.inspect
  end
end