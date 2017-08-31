# == Schema Information
#
# Table name: site_level_taxonomies
#
#  id                 :integer          not null, primary key
#  value              :string(255)
#  tid                :integer
#  parent_tid         :integer
#  friendly_url       :text(65535)
#  description        :text(65535)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  page_title         :text(65535)
#  site_membership    :string(255)
#  generate_page      :boolean
#  asset_last_updated :datetime
#  page_type          :string(255)
#

require 'test_helper'

class SiteLevelTaxonomyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
