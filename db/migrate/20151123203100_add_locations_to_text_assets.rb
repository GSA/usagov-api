class AddLocationsToTextAssets < ActiveRecord::Migration
  def change
    add_column :text_assets, :locations, :text
  end
end
