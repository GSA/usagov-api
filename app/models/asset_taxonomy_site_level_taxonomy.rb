# == Schema Information
#
# Table name: asset_taxonomy_site_level_taxonomies
#
#  id                     :integer          not null, primary key
#  site_level_taxonomy_id :integer
#  asset_taxonomy_id      :integer
#

class AssetTaxonomySiteLevelTaxonomy < ActiveRecord::Base
  belongs_to :site_level_taxonomy
  belongs_to :asset_taxonomy

end
