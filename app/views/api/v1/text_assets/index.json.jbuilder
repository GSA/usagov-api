json.metadata do
  json.count      @results["hits"]["total"]
  json.page       @query.page
  json.page_size  @query.page_size
  json.pages      calculate_pages(@results["hits"]["total"],@query.page_size)
  if Rails.env.development?
    json.raw    @query_body
  end
end
json.results @results["hits"]["hits"] do |result|
  if params[:results_filter]
    json.merge! result["_source"].slice(*params[:results_filter].to_s.split(","))
  elsif result["_source"]["status"] == "Deleted"
    json.merge! result["_source"].slice("id","title","status","created_at","updated_at","changed_at")
  else
    json.merge! result["_source"]
  end
end
