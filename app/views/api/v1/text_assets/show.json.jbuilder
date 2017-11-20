json.metadata do
  if @results["hits"]["hits"].count > 0
    json.exists true
  else
    json.exists false
  end
end
json.result do 
  @results["hits"]["hits"].each do |result|

    if result["_source"]["status"] == "Deleted"
      json.merge! result["_source"].slice("id","title","status","created_at","updated_at","changed_at")
    else
      json.merge! result["_source"]
    end
  end
end