# == Schema Information
#
# Table name: text_asset_agency_taxonomies
#
#  id                 :integer          not null, primary key
#  text_asset_id      :integer
#  agency_taxonomy_id :integer
#

class TextAssetAgencyTaxonomy < ActiveRecord::Base


  belongs_to :agency_taxonomy
  belongs_to :text_asset
end
