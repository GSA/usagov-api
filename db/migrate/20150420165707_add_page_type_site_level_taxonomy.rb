class AddPageTypeSiteLevelTaxonomy < ActiveRecord::Migration
  def change
    add_column :site_level_taxonomies, :page_type, :string
  end
end
