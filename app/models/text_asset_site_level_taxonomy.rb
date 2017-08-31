# == Schema Information
#
# Table name: text_asset_site_level_taxonomies
#
#  id                     :integer          not null, primary key
#  text_asset_id          :integer
#  site_level_taxonomy_id :integer
#

class TextAssetSiteLevelTaxonomy < ActiveRecord::Base

  belongs_to :site_level_taxonomy
  belongs_to :text_asset
end
