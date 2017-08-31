# == Schema Information
#
# Table name: sites
#
#  id    :integer          not null, primary key
#  value :string(255)
#

class Site < ActiveRecord::Base
  ### FOR ALL PRACTICAL PURPOSES, THIS IS ACTUALLY THE FOR_USE_BY FIELDS VALUE
  has_many :text_asset_sites, dependent: :destroy
  has_many :text_assets, through: :text_asset_sites

  has_many :directory_record_sites, dependent: :destroy
  has_many :directory_records, through: :directory_record_sites
end
