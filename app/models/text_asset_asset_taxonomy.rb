# == Schema Information
#
# Table name: text_asset_asset_taxonomies
#
#  id                :integer          not null, primary key
#  text_asset_id     :integer
#  asset_taxonomy_id :integer
#

class TextAssetAssetTaxonomy < ActiveRecord::Base

  belongs_to :asset_taxonomy
  belongs_to :text_asset
end
