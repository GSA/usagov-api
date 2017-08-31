require 'elasticsearch'
ELASTIC_SEARCH_CONFIG = YAML.load(ERB.new(File.read("#{Rails.root}/config/elasticsearch.yml")).result)[Rails.env]

ELASTIC_SEARCH_CLIENT = Elasticsearch::Client.new({
  hosts: ELASTIC_SEARCH_CONFIG["hosts"],
  log: ELASTIC_SEARCH_CONFIG["log"]
})

Elasticsearch::Model.client = ELASTIC_SEARCH_CLIENT