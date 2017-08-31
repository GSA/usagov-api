class CreateSiteLevelTaxonomies < ActiveRecord::Migration
  def change
    create_table :site_level_taxonomies do |t|
      t.string :value
      t.integer :tid
      t.integer :parent_tid
      t.text :friendly_url
      t.text :description
      t.timestamps null: false
    end
  end
end
