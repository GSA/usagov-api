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
#

require 'test_helper'

class AgencyTaxonomyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
