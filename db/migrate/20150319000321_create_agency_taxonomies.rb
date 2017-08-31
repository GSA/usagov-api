class CreateAgencyTaxonomies < ActiveRecord::Migration
  def change
    create_table :agency_taxonomies do |t|
      t.string :value
      t.integer :tid
      t.integer :parent_tid
      t.timestamps null: false
    end
  end
end
