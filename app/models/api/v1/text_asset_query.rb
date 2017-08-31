# Is a Query tool for Text Assets
class Api::V1::TextAssetQuery
	include ActiveModel::Validations
	include ActiveModel::Conversion
	extend ActiveModel::Naming

	# API_FIELD => DRUPAL_FIELD

	INDEX_NAME = "drupal_text_asset_index"

	FIELD_MAPPINGS = {
		"id" => {
			:drupal_field => "id",
			:format => "formatters/pass_thru",
			:show_when_archived => true
		},
		"title" => {
			:drupal_field => "title",
			:format => "formatters/pass_thru"
		},
		"summary" => {
			:drupal_field => "field_description",
			:format => "formatters/pass_thru"
		},
		"language" => {
			:drupal_field  => "search_api_language",
			:format => "formatters/pass_thru"
		},
		"topics" =>{
			:drupal_field => "field_asset_topic_taxonomy:parents_all:name",
			:format => "formatters/pass_thru"
		},
		"html" =>{
			:drupal_field => "body:value",
			:format => "formatters/pass_thru"
		},
		"created_at" => {
			:drupal_field => "created",
			:format => "formatters/timestamp"
		},
		"updated_at" => {
			:drupal_field => "changed",
			:format => "formatters/timestamp"
		},
		"contact_center_only" => {
			:drupal_field  => "field_contact_center_info",
			:format => "formatters/pass_thru"
		},
		"for_use_by" => {
			:drupal_field  => "field_for_use_by_text",
			:format => "formatters/pass_thru"
		},
		"status" => {
			:drupal_field  => "deleted",
			:format => "formatters/status",
			:show_when_archived => true
		},
		"tags" => {
			:drupal_field  => "field_content_tags:name",
			:format => "formatters/pass_thru"
		},
		"location" => {
			:drupal_field  => "id",
			:format => "formatters/url_location"
		},
		"owner" => {
			:drupal_field  => "field_owner:name",
			:format => "formatters/pass_thru"
		},
		"author" => {
			:drupal_field  => "author:name",
			:format => "formatters/pass_thru"
		}
	}

	def initialize(attributes = {})
		attributes.each do |name,value|
			send("#{name}=", value)
		end
	end

	def self.build_query(params = {})
		q = params[:query] ? "*#{params[:query]}*" : nil
		page_size = params[:page_size]
		page = params[:page] || 0
		from = params[:from].to_i || 0 
		sort = params[:sort] || "changed:desc"
		

		terms = params[:terms_filter] ? params[:terms_filter].split('|') : [ ]
		terms_filter = {}
		terms.each do |term|
			term_array=term.split(':')
			if FIELD_MAPPINGS[term_array[0]]
				terms_filter[FIELD_MAPPINGS[term_array[0]][:drupal_field]] = term_array[1].split(',')
			end
		end
		if q
			body = { 
				query: { 
					bool: {
						must: [
							{
								multi_match: {
									query: q,
									fields: ["author:name^1.0","body:value^1.0","field_alt_text^1.0","field_asset_topic_taxonomy:parents_all:name^1.0","field_asset_topic_taxonomy:parents_all:uuid^1.0","field_contact_center_info:value^1.0","field_description^1.0","field_embed_code^1.0","field_info_for_contact_center^1.0","field_owner:name^1.0","title^5.0"]
								}
							}
						] 
					}
				},
				size: page_size, 
				from: from
			}
		else
			body = { 
				size: page_size, 
				from: from
			}
		end
		if !terms_filter.empty?
			body[:query] = {} if body[:query] == nil
			body[:query][:bool] = {} if body[:query][:bool] == nil
			body[:query][:bool][:must] = [] if body[:query][:bool][:must] == nil
			body[:query][:bool][:must] << { terms: terms_filter }
		end

		date_filter = params[:date_filter] ? params[:date_filter].split(",") : []
		date_range = {}
		if !date_filter.empty?
			date_range[:changed] = { }
			date_range[:changed][:gte] = Time.parse(date_filter[0]).to_i
			date_range[:changed][:lte] = Time.parse(date_filter[1]).to_i if date_filter[1]
		end
		if !date_range.empty?
			body[:query] = {} if body[:query] == nil
			body[:query] = {} if body[:query] == nil
			body[:query][:bool] = {} if body[:query][:bool] == nil
			body[:query][:bool][:must] = [] if body[:query][:bool][:must] == nil
			body[:query][:bool][:must] << {range: date_range}
		end
		body
	end
	
	def self.search(body = {})
		ELASTIC_SEARCH_CLIENT.search index: index_name,
				body: body, type: type
	end

	def self.get(params = {})
		ELASTIC_SEARCH_CLIENT.get index: index_name,
			id: params[:id]
	end

	def self.field_mappings
		FIELD_MAPPINGS
	end

	def self.facet
		# ELASTIC_SEARCH_CLIENT.indices.stats fielddata: true, filter_cache: true, fields: 'workflow_state_name'

		ELASTIC_SEARCH_CLIENT.search index: 'drupal_text_asset_index', type: 'text_asset_index', #id: 12482,
            body: {
            	query: { 
					bool: {
						must: [
							{
								multi_match: {
									query: "*http://gibill.custhelp.com/*",
									fields: ["author:name^1.0","body:value^1.0","field_alt_text^1.0","field_asset_topic_taxonomy:parents_all:name^1.0","field_asset_topic_taxonomy:parents_all:uuid^1.0","field_contact_center_info:value^1.0","field_description^1.0","field_embed_code^1.0","field_info_for_contact_center^1.0","field_owner:name^1.0","title^5.0"]
								}
							}
						] 
					}
				}
			}
		# ELASTIC_SEARCH_CLIENT.get 
		# {
		#     "query" : {
		#         "match_all" : {  }
		#     },
		#     "facets" : {
		#         "tag" : {
		#             "terms" : {
		#                 "field" : "tag",
		#                 "size" : 10
		#             }
		#         }
		#     }
		# }

	end

	def self.index_name
		INDEX_NAME
	end

	def self.type
		"text_asset_index"
	end

	def persisted?
		false
	end

end