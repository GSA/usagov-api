class CreateUsaGovTextAssets < ActiveRecord::Migration
  def change
    create_table :usa_gov_text_assets do |t|
      t.string :title
      t.text :summary
      t.string :language
      t.text :html
      t.datetime :created_at
      t.datetime :updated_at
      t.boolean :contact_center_only

      t.timestamps null: false
    end

    create_table :usa_gov_text_asset_uses

    create_table :usa_gov_text_asset_usa_gov_asset_topic_taxonomies do |t|
      t.integer :usa_gov_text_asset_id
      t.integer :usa_gov_text_asset_topic_taxonomy_id
    end
  end
end
