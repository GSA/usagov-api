namespace :elastic_search do

	desc "update specified index"
	task :update_index, [:index_name] => :environment do |t, args|
		if args[:index_name]
			index_name = "directory_records"
			ELASTIC_SEARCH_CLIENT.indices.close index: index_name
			ELASTIC_SEARCH_CLIENT.indices.put_settings index: index_name, body: {
			    index: {
			        analysis: {
			            analyzer: {
			                default: {
			                    tokenizer: "letter",
			                    filter: ["standard", "lowercase", "my_ascii_folding"]
			                }
			            },
			            filter: {
			                my_ascii_folding: {
			                    type: "asciifolding",
			                    preserve_original: "true"
			                }
			            }
			        }
			    }
			}
			ELASTIC_SEARCH_CLIENT.indices.open index: index_name
		else
			puts "Please specify an index"
		end
	end

	desc "update"
	task :update_indexes do |t,args|
		ELASTIC_SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/elasticsearch.yml")[Rails.env]

		ELASTIC_SEARCH_CLIENT = Elasticsearch::Client.new({
		  hosts: ELASTIC_SEARCH_CONFIG["hosts"],
		  log: ELASTIC_SEARCH_CONFIG["log"]
		})
		indices = ["drupal_all_nodes_index", "drupal_text_asset_index", "drupal_html_asset_index",
			"drupal_multimedia_asset_index", "drupal_file_asset_index", "drupal_state_details_index",
			"text_multimedia_html_index"]
		indices.each do |index_name|
			ELASTIC_SEARCH_CLIENT.indices.close index: index_name
			ELASTIC_SEARCH_CLIENT.indices.put_settings index: index_name, body: {
			    index: {
			        analysis: {
			            analyzer: {
			                default: {
			                    tokenizer: "usa_gov_tokenizer",
			                    filter: ["standard", "lowercase", "my_ascii_folding"]
			                }
			            },
			            filter: {
			                my_ascii_folding: {
			                    type: "asciifolding",
			                    preserve_original: "true"
			                }
			            },
			            tokenizer: {
			            	usa_gov_tokenizer: {
			            		type: "letter"
			            	}
			            }

			        }
			    }
			}
			ELASTIC_SEARCH_CLIENT.indices.open index: index_name
		end
	end
end
