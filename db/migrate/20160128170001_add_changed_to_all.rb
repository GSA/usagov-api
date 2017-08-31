class AddChangedToAll < ActiveRecord::Migration
  def change
    add_column :agency_taxonomies, :changed_at, :datetime
    add_column :asset_taxonomies, :changed_at, :datetime
    add_column :directory_records, :changed_at, :datetime
    add_column :multimedia_assets, :changed_at, :datetime
    add_column :site_level_taxonomies, :changed_at, :datetime
    add_column :state_details, :changed_at, :datetime
    add_column :text_assets, :changed_at, :datetime
  end
end
