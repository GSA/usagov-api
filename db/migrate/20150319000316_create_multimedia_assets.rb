class CreateMultimediaAssets < ActiveRecord::Migration
  def change
    create_table :multimedia_assets do |t|
      t.integer :node_id
      t.string :title
      t.text :summary
      t.string :language
      t.string :media_type
      t.text :widget_code
      t.string :high_res_version
      t.string :status
      t.string :file_name
      t.string :file_location
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :multimedia_asset_sites do |t|
      t.integer :multimedia_asset_id
      t.integer :site_id
    end

    create_table :multimedia_asset_agency_taxonomies do |t|
      t.integer :multimedia_asset_id
      t.integer :agency_taxonomy_id
    end

    create_table :multimedia_asset_asset_taxonomies do |t|
      t.integer :multimedia_asset_id
      t.integer :asset_taxonomy_id
    end
  end
end
