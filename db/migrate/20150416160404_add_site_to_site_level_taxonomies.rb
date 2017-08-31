class AddSiteToSiteLevelTaxonomies < ActiveRecord::Migration
  def change
    add_column :site_level_taxonomies, :site_membership, :string
  end
end
