# == Schema Information
#
# Table name: text_assets
#
#  id                  :integer          not null, primary key
#  node_id             :integer
#  title               :string(255)
#  summary             :text(65535)
#  language            :string(255)
#  html                :text(65535)
#  created_at          :datetime
#  updated_at          :datetime
#  changed_at          :datetime
#  contact_center_only :text(65535)
#  status              :string(255)
#  location            :string(255)
#  owner               :string(255)
#  author              :string(255)
#  for_use_by          :string(255)
#

class TextAsset < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  serialize :locations, JSON
  serialize :for_use_by, JSON

  #has_many :text_asset_sites, dependent: :destroy
  #has_many :sites, through: :text_asset_sites

  has_many :text_asset_agency_taxonomies, dependent: :destroy
  has_many :agency_taxonomies, through: :text_asset_agency_taxonomies

  has_many :text_asset_asset_taxonomies, dependent: :destroy
  has_many :asset_taxonomies, through: :text_asset_asset_taxonomies

  has_many :text_asset_site_level_taxonomies, dependent: :destroy
  has_many :site_level_taxonomies, through: :text_asset_site_level_taxonomies

  TEXT_QUERY_FIELDS = ["title^100","summary^5","html^-1"]
  def self.TEXT_QUERY_FIELDS
    TEXT_QUERY_FIELDS
  end
  def self.create_or_update_by_xml(node)
    ta = TextAsset.find_or_create_by(:node_id => node.xpath('.//nid').first.try(:content))
    ta.title = node.xpath('.//title').first.try(:content)
    ta.html = node.xpath('.//body').xpath('.//value').first.try(:content)
    ta.summary = node.xpath('.//field_description').xpath('.//value').first.try(:content)
    ta.language = node.xpath('.//field_language').first.try(:content)
    ta.contact_center_only = node.xpath(".//field_contact_center_info").xpath('.//value').first.try(:content)

    locations_list = node.xpath('.//locations').xpath('.//value')
    ta.locations = []
    locations_list.each do |location|
      ta.locations << { page_title: location.xpath(".//page_title").children.first.try(:content),
        url: location.xpath('.//url').children.first.try(:content) }
    end

    ta.for_use_by = []
    for_use_by_list = node.xpath('.//field_for_use_by_text').xpath(".//value")
    for_use_by_list.each do |site|
      site = site.try(:content)
      ta.for_use_by << site if site
    end
    # ta.sites = []
    # for_use_by_list.each do |site|
    #   site_name = site.try(:content)
    #   ta.sites << Site.find_or_create_by(value: site_name) if site_name
    # end

    ta.asset_taxonomies = []
    asset_topic_list = node.xpath('.//field_asset_topic_taxonomy').xpath(".//tid")
    asset_topic_list.each do |topic|
      topic_name = topic.try(:content)
      asset_taxonomy =  topic_name ? AssetTaxonomy.find_or_create_by(tid: topic_name) : nil
      ta.asset_taxonomies << asset_taxonomy if asset_taxonomy
    end

    ta.site_level_taxonomies = []
    ta.agency_taxonomies = []
    agency_list = node.xpath('.//field_content_tags').xpath(".//tid")
    agency_list.each do |topic|
      topic_name = topic.try(:content)
      agency_taxonomy =  topic_name ? AgencyTaxonomy.find_or_create_by(tid: topic_name) : nil
      ta.agency_taxonomies << agency_taxonomy if agency_taxonomy
    end

    created_at = node.at_xpath('.//created').children.first.try(:content)
    changed_at = node.at_xpath('.//changed').children.first.try(:content)
    ta.created_at = Time.at(created_at.to_i)
    ta.updated_at = Time.at(changed_at.to_i)
    ta.changed_at = Time.at(changed_at.to_i)


    ta.site_level_taxonomies.each do |slt|
      if slt.asset_last_updated == nil
        slt.asset_last_updated = ta.changed_at
      else
        slt.asset_last_updated = ta.changed_at if ta.changed_at > slt.asset_last_updated
      end
      slt.save!
    end
    ta.asset_taxonomies.each do |at|
      at.site_level_taxonomies.each do |slt|
        if slt.asset_last_updated == nil
          slt.asset_last_updated = ta.changed_at
        else
          slt.asset_last_updated = ta.changed_at if ta.changed_at > slt.asset_last_updated
        end
        slt.save!
      end
    end
    ta.status = status_lookup(node.xpath('.//status').first.try(:content))
    deleted = node.xpath('.//deleted').children.first.try(:content)
    if deleted == "1"
      ta.status = status_lookup("2")
    end
    ta.save!
  end

  def as_indexed_json(options = {})
    json = Jbuilder.encode do |json|
      json.id self.node_id
      json.title self.title
      json.summary self.summary
      json.language self.language
      json.html self.html
      json.contact_center_only self.contact_center_only
      json.status self.status
      json.location self.locations
      #json.for_use_by self.sites.map(&:value)
      json.for_use_by self.for_use_by
      json.topics self.asset_taxonomies.map(&:value_chain)
      json.tags self.agency_taxonomies.map(&:value)
      json.created_at self.created_at
      json.updated_at self.updated_at
      json.changed_at self.changed_at
    end
    JSON.parse(json)
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
    "text_assets"
  end

  def self.type
    "text_asset"
  end
end
