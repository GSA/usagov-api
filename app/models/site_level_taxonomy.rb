# == Schema Information
#
# Table name: site_level_taxonomies
#
#  id                 :integer          not null, primary key
#  value              :string(255)
#  tid                :integer
#  parent_tid         :integer
#  friendly_url       :text(65535)
#  description        :text(65535)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  changed_at         :datetime         not null
#  page_title         :text(65535)
#  site_membership    :string(255)
#  generate_page      :boolean
#  asset_last_updated :datetime
#  page_type          :string(255)
#

class SiteLevelTaxonomy < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :asset_taxonomy_site_level_taxonomies, dependent: :destroy
  has_many :asset_taxonomies, through: :asset_taxonomy_site_level_taxonomies

  has_many :text_asset_site_level_taxonomies, dependent: :destroy
  has_many :text_assets, through: :text_asset_site_level_taxonomies

  has_many :multimedia_asset_site_level_taxonomies, dependent: :destroy
  has_many :multimedia_assets, through: :multimedia_asset_site_level_taxonomies

  belongs_to :parent, :class_name => "SiteLevelTaxonomy", :foreign_key => "parent_tid", :primary_key => "tid"
  has_many :children, :class_name => "SiteLevelTaxonomy", :foreign_key => "parent_tid", :primary_key => "tid"


  def self.create_or_update_by_xml(node)
    term = SiteLevelTaxonomy.find_or_create_by(tid: node.xpath('.//tid').first.try(:content))
    term.value = node.xpath('.//name').first.try(:content)
    term.parent_tid = node.xpath('.//parentTerm/tid').first.try(:content)
    asset_topic_list = node.xpath('.//field_asset_topic_taxonomy')
    term.asset_taxonomies = []
    asset_topic_list.each do |topic|
      topic_id = topic.xpath('.//tid').first.try(:content)
      if topic_id
        term.asset_taxonomies << AssetTaxonomy.find_or_create_by(tid: topic_id)
      end
    end
    term.asset_taxonomies = term.asset_taxonomies.uniq
    term.description = node.xpath('.//field_meta_description').xpath('.//value').first.try(:content)
    term.friendly_url = node.xpath('.//field_friendly_url').xpath('.//value').first.try(:content)
    term.page_title = node.xpath('.//field_page_title').xpath('.//value').first.try(:content)
    term.generate_page = node.xpath('.//field_generate_page').xpath('.//value').first.try(:content) == "yes" ? true : false
    if( node.xpath(".//field_generate_page").xpath('.//value').first.try(:content) == "yes" )
      nodes_included = node.xpath(".//field_asset_order_content").xpath('.//target_id')
      term.text_assets = []
      nodes_included.each do |node|
        node_id = node.try(:content)
        term.text_assets << TextAsset.find_by(node_id: node_id) if TextAsset.find_by(node_id: node_id)
      end
    end
    term.page_type = node.xpath('.//field_type_of_page_to_generate').xpath('.//value').first.try(:content)

    if term.asset_last_updated == nil
      if term.updated_at != nil
        term.asset_last_updated = term.updated_at
      else
        term.asset_last_updated = Time.new
      end
    end
    term.asset_last_updated = term.updated_at unless term.asset_last_updated > term.updated_at
    term.changed_at = term.asset_last_updated
    term.save!
  end

  def full_url
    if generate_page
      if friendly_url.nil?
        return nil
      elsif site_membership == "Kids.gov"
        return friendly_url
      elsif site_membership == "USA.gov"
        return "https://#{ENV['CMP_USAGOV_HOST']}#{friendly_url}"
      elsif site_membership == "GobiernoUSA.gov"
        return "https://#{ENV['CMP_GOBIERNOGOV_HOST']}#{friendly_url}"
      elsif site_membership == "Blog.USA.gov"
        return "https://#{ENV['CMP_BLOGGOV_HOST']}#{friendly_url}"
      else
        return nil
      end
    else
      return nil
    end
  end

  def full_text_assets
    temp_text_assets  = []
    temp_text_assets << text_assets
    asset_taxonomies.each do |asset|
      temp_text_assets << asset.text_assets
    end
    temp_text_assets.flatten.uniq
  end

  def full_text_assets_content
    temp_content = []
    full_text_assets.each do |fta|
      temp_content << fta.html
    end
    temp_content.join " "
  end

  def most_recent_update
    updated_date = changed_at
    full_text_assets.each do |fta|
      updated_date = fta.changed_at if fta.changed_at.to_i > updated_date.to_i
    end
    updated_date
  end

  def top_level_parent
    current_node = self
    while current_node.parent
      current_node = current_node.parent
    end
    current_node
  end
end
