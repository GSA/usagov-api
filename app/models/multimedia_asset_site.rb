# == Schema Information
#
# Table name: multimedia_asset_sites
#
#  id                  :integer          not null, primary key
#  multimedia_asset_id :integer
#  site_id             :integer
#

class MultimediaAssetSite < ActiveRecord::Base
  belongs_to :multimedia_asset
  belongs_to :site

end
