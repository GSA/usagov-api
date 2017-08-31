# == Schema Information
#
# Table name: multimedia_assets
#
#  id               :integer          not null, primary key
#  node_id          :integer
#  title            :string(255)
#  summary          :text(65535)
#  language         :string(255)
#  media_type       :string(255)
#  widget_code      :text(65535)
#  high_res_version :string(255)
#  status           :string(255)
#  file_name        :string(255)
#  file_location    :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  changed_at       :datetime
#

require 'elasticsearch/model'
class MultimediaAsset < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  #has_many :multimedia_asset_sites, dependent: :destroy
  #has_many :sites, through: :multimedia_asset_sites

  has_many :multimedia_asset_agency_taxonomies, dependent: :destroy
  has_many :agency_taxonomies, through: :multimedia_asset_agency_taxonomies

  has_many :multimedia_asset_asset_taxonomies, dependent: :destroy
  has_many :asset_taxonomies, through: :multimedia_asset_asset_taxonomies

  has_many :multimedia_asset_site_level_taxonomies, dependent: :destroy
  has_many :site_level_taxonomies, through: :multimedia_asset_site_level_taxonomies

  TEXT_QUERY_FIELDS = ["media_type^1.0","widget_code^1.0","summary^3.0","language^1.0","title^5.0"]
  def self.TEXT_QUERY_FIELDS
    TEXT_QUERY_FIELDS
  end

  def as_indexed_json(options = {})
    json = Jbuilder.encode do |json|
      json.id self.node_id
      json.title self.title
      json.language self.language
      json.summary self.summary
      json.media_type self.media_type
      json.widget_code self.widget_code
      json.high_res_version self.high_res_version
      json.status self.status
      json.file_name self.file_name
      json.file_location self.file_location ? self.file_location.gsub("s3://","https://gsa-cmp-fileupload.s3.amazonaws.com/") : nil
      json.created_at self.created_at
      json.updated_at self.updated_at
      json.changed_at self.changed_at
    end
    JSON.parse(json)
  end


  def self.create_or_update_by_xml(node)
    ma = MultimediaAsset.find_or_create_by(:node_id => node.xpath('.//nid').first.try(:content))
    ma.title = node.xpath('.//title').first.try(:content)
    ma.language = node.xpath('.//field_language').first.try(:content)
    ma.summary = node.xpath('.//field_description').xpath(".//value").first.try(:content)
    ma.media_type = node.xpath("//field_media_type").xpath(".//value").first.try(:content)
    ma.widget_code = node.xpath('.//field_widget_code').xpath(".//value").first.try(:content)
    ma.high_res_version = node.xpath('.//field_high_res_version').xpath(".//value").first.try(:content)
    ma.status = status_lookup(node.xpath('.//status').first.try(:content))
    deleted = node.xpath('.//deleted').children.first.try(:content)
    if deleted == "1"
      ma.status = status_lookup("2")
    end
    ma.file_name = node.xpath('.//field_file_media').xpath(".//filename").first.try(:content)
    ma.file_location = node.xpath('.//field_file_media').xpath(".//uri").first.try(:content)

    created_at = node.at_xpath('.//created').children.first.try(:content)
    changed_at = node.at_xpath('.//changed').children.first.try(:content)
    ma.created_at = Time.at(created_at.to_i)
    ma.updated_at = Time.at(changed_at.to_i)
    ma.changed_at = Time.at(changed_at.to_i)

    # for_use_by_list = node.xpath('.//field_for_use_by_text').xpath(".//value")
    # ma.sites = []
    # for_use_by_list.each do |site|
    #   site_name = site.try(:content)
    #   ma.sites << Site.find_or_create_by(value: site_name) if site_name
    # end

    ma.asset_taxonomies = []
    asset_topic_list = node.xpath('.//field_asset_topic_taxonomy')
    asset_topic_list.each do |topic|
      topic_name = topic.xpath(".//tid").first.try(:content)
      asset_taxonomy =  topic_name ? AssetTaxonomy.find_by(tid: topic_name) : nil
      ma.asset_taxonomies << asset_taxonomy if asset_taxonomy
    end
    ma.save!
  end

  def self.search(body = {})
    ELASTIC_SEARCH_CLIENT.search index: index_name,
        body: body, type: type
  end

  def self.get(params = {})
    ELASTIC_SEARCH_CLIENT.get index: index_name,
      id: params[:id]
  end


  def self.index_name
    "multimedia_assets"
  end

  def self.type
    "multimedia_asset"
  end

end
