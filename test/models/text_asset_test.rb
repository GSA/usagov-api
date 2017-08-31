# == Schema Information
#
# Table name: text_assets
#
#  id                  :integer          not null, primary key
#  node_id             :integer
#  title               :string(255)
#  summary             :text(65535)
#  language            :string(255)
#  html                :text(65535)
#  created_at          :datetime
#  updated_at          :datetime
#  contact_center_only :text(65535)
#  status              :string(255)
#  location            :string(255)
#  owner               :string(255)
#  author              :string(255)
#

require 'test_helper'

class TextAssetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
