# == Schema Information
#
# Table name: directory_records
#
#  id                   :integer          not null, primary key
#  node_id              :integer
#  title                :string(255)
#  language             :string(255)
#  alpha_order_name     :string(255)
#  street_one           :string(255)
#  street_two           :string(255)
#  city                 :string(255)
#  state                :string(255)
#  zip                  :string(255)
#  contact_links        :text(65535)
#  description          :text(65535)
#  directory_type       :string(255)
#  donated_money        :string(255)
#  government_branch    :string(255)
#  phone_number         :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  status               :string(255)
#  parent_node_id       :integer
#  state_detail_node_id :integer
#

require 'test_helper'

class DirectoryRecordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
