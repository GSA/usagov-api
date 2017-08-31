class AssetLastUpdated < ActiveRecord::Migration
  def change
    add_column :site_level_taxonomies, :asset_last_updated, :datetime
  end
end
