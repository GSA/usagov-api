# == Schema Information
#
# Table name: directory_record_sites
#
#  id                  :integer          not null, primary key
#  directory_record_id :integer
#  site_id             :integer
#

class DirectoryRecordSite < ActiveRecord::Base
  belongs_to :directory_record
  belongs_to :site
end
