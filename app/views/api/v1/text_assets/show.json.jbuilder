json.metadata do
  if @results["hits"]["hits"].count > 0
    json.exists true
  else
    json.exists false
  end
end
json.result do 
  @results["hits"]["hits"].each do |result|
    json.merge! result["_source"]
  end
end