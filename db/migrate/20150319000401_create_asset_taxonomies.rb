class CreateAssetTaxonomies < ActiveRecord::Migration
  def change
    create_table :asset_taxonomies do |t|
      t.string :value
      t.integer :tid
      t.integer :parent_tid
      t.timestamps null: false
    end

    create_table :asset_taxonomy_site_level_taxonomies do |t|
      t.integer :site_level_taxonomy_id
      t.integer :asset_taxonomy_id
    end
  end
end
