class AddFieldsToDirectoryRecords < ActiveRecord::Migration
  def change
    add_column :directory_records, :group_by, :string
    add_column :directory_records, :notify_marketing_team, :string
    add_column :directory_records, :scoap_member, :string
    add_column :directory_records, :show_on_az_index, :string
    add_column :directory_records, :website_links, :text
    add_column :directory_records, :acronym, :string
    add_column :directory_records, :cfo_agency, :string
    add_column :directory_records, :for_use_by_text, :string
  end
end
