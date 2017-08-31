# == Schema Information
#
# Table name: multimedia_asset_site_level_taxonomies
#
#  id                     :integer          not null, primary key
#  multimedia_asset_id    :integer
#  site_level_taxonomy_id :integer
#

class MultimediaAssetSiteLevelTaxonomy < ActiveRecord::Base
  belongs_to :multimedia_asset
  belongs_to :site_level_taxonomy

end
