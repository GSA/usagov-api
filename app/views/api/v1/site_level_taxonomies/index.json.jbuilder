json.metadata do
  json.count      @results.total_count
  json.page       params[:page]
  json.page_size  params[:page_size]
  json.pages      @results.total_pages
end

json.results @results do |result|
  json.set! :id, result.tid
  json.set! :label, result.value
  json.parent do
    if result.parent
      json.set! :id, result.parent.tid
      json.set! :label, result.parent.value
    else
      json.nil!
    end
  end
  json.children result.children do |child_result|
    json.set! :id, child_result.tid
    json.set! :label, child_result.value
  end
end