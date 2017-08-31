class AlterContactCenterOnlyField < ActiveRecord::Migration
  def change
    remove_column :usa_gov_text_assets, :contact_center_only, :boolean
    remove_column :text_assets, :contact_center_only, :text
    add_column :usa_gov_text_assets, :contact_center_only, :text
    add_column :text_assets, :contact_center_only, :text
  end
end