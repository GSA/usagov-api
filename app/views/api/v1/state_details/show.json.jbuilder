json.metadata do
  if @results["hits"]["hits"].count > 0
    json.exists true
  else
    json.exists false
  end
end
json.result do 
  json.state_detail do
    @results["hits"]["hits"].each do |result|
      json.merge! result["_source"]
    end
  end
  json.directory_records do
    json.array! @directory_records["hits"]["hits"] do |directory_record| 
      json.merge! directory_record["_source"]
    end
  end
end