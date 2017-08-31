# == Schema Information
#
# Table name: agency_taxonomies
#
#  id         :integer          not null, primary key
#  value      :string(255)
#  tid        :integer
#  parent_tid :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  changed_at :datetime         not null
#

class AgencyTaxonomy < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :multimedia_asset_agency_taxonomies, dependent: :destroy
  has_many :multimedia_assets

  belongs_to :parent, :class_name => "AgencyTaxonomy", :foreign_key => "parent_tid", :primary_key => "tid"
  has_many :children, :class_name => "AgencyTaxonomy", :foreign_key => "parent_tid", :primary_key => "tid"


  def self.create_or_update_by_xml(node)
  	term = AgencyTaxonomy.find_or_create_by(tid: node.xpath('.//tid').first.try(:content))
  	term.value = node.xpath('.//name').first.try(:content)
  	term.parent_tid = node.xpath('.//parentTerm/tid').first.try(:content)
  	term.save!
  end

end
