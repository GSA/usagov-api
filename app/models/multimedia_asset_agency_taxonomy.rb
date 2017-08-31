# == Schema Information
#
# Table name: multimedia_asset_agency_taxonomies
#
#  id                  :integer          not null, primary key
#  multimedia_asset_id :integer
#  agency_taxonomy_id  :integer
#

class MultimediaAssetAgencyTaxonomy < ActiveRecord::Base
  belongs_to :multimedia_asset
  belongs_to :agency_taxonomy

end
