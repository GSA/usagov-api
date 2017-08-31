json.metadata do
  json.count      @results.total_count
  json.page       params[:page]
  json.page_size  params[:page_size]
  json.pages      @results.total_pages
end
json.results @results do |result|
  json.set! :id, result.tid
  json.set! :title, result.page_title
  json.set! :url, result.full_url
  json.set! :summary, result.description
  json.set! :content, result.full_text_assets_content
  json.set! :updated_at, result.asset_last_updated
end