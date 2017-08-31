class CreateTextAssets < ActiveRecord::Migration
  def change
    create_table :text_assets do |t|
      t.integer :node_id
      t.string :title
      t.text :summary
      t.string :language
      t.text :html
      t.datetime :created_at
      t.datetime :updated_at
      t.text :contact_center_only
      t.string :status
      t.string :location
      t.string :owner
      t.string :author
    end

    create_table :sites do |t|
      t.string :value
    end

    create_table :text_asset_sites do |t|
      t.integer :text_asset_id
      t.integer :site_id
    end

    create_table :text_asset_agency_taxonomies do |t|
      t.integer :text_asset_id
      t.integer :agency_taxonomy_id
    end

    create_table :text_asset_asset_taxonomies do |t|
      t.integer :text_asset_id
      t.integer :asset_taxonomy_id
    end

    create_table :text_asset_site_level_taxonomies do |t|
      t.integer :text_asset_id
      t.integer :site_level_taxonomy_id
    end

  end
end
