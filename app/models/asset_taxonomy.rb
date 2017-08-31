# == Schema Information
#
# Table name: asset_taxonomies
#
#  id         :integer          not null, primary key
#  value      :string(255)
#  tid        :integer
#  parent_tid :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  changed_at :datetime         not null
#

class AssetTaxonomy < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :asset_taxonomy_site_level_taxonomies, dependent: :destroy
  has_many :site_level_taxonomies, through: :asset_taxonomy_site_level_taxonomies

  has_many :text_asset_asset_taxonomies, dependent: :destroy
  has_many :text_assets, through: :text_asset_asset_taxonomies


  def value_chain
    value_chain =  [ self[:value] ]
    parent_holder = self.parent
    while parent_holder
      value_chain << parent_holder.value
      parent_holder = parent_holder.parent
    end
    value_chain
  end

  belongs_to :parent, :class_name => "AssetTaxonomy", :foreign_key => "parent_tid", :primary_key => "tid"
  has_many :children, :class_name => "AssetTaxonomy", :foreign_key => "parent_tid", :primary_key => "tid"


  def self.create_or_update_by_xml(node)
    term = AssetTaxonomy.find_or_create_by(tid: node.xpath('.//tid').first.try(:content))
    term.value = node.xpath('.//name').first.try(:content)
    term.parent_tid = node.xpath('.//parentTerm/tid').first.try(:content)
    term.changed_at = nil
    term.save!
  end


end
