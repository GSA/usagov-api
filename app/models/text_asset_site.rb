# == Schema Information
#
# Table name: text_asset_sites
#
#  id            :integer          not null, primary key
#  text_asset_id :integer
#  site_id       :integer
#

class TextAssetSite < ActiveRecord::Base

  belongs_to :text_asset
  belongs_to :site
end
