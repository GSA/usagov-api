class AddGeneratePage < ActiveRecord::Migration
  def change
    add_column :site_level_taxonomies, :generate_page, :boolean
  end
end
