# == Schema Information
#
# Table name: multimedia_assets
#
#  id               :integer          not null, primary key
#  node_id          :integer
#  title            :string(255)
#  summary          :text(65535)
#  language         :string(255)
#  media_type       :string(255)
#  widget_code      :text(65535)
#  high_res_version :string(255)
#  status           :string(255)
#  file_name        :string(255)
#  file_location    :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'test_helper'

class MultimediaAssetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
