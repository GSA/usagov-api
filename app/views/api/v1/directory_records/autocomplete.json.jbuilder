
json.results @results do |result|
  json.set! :id, result.node_id
  json.set! :title, result.title
  json.set! :source_url, result.source_url
end