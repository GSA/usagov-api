# == Schema Information
#
# Table name: multimedia_asset_asset_taxonomies
#
#  id                  :integer          not null, primary key
#  multimedia_asset_id :integer
#  asset_taxonomy_id   :integer
#

class MultimediaAssetAssetTaxonomy < ActiveRecord::Base
  belongs_to :multimedia_asset
  belongs_to :asset_taxonomy

end
