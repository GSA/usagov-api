class AddPageTitle < ActiveRecord::Migration
  def change
    add_column :site_level_taxonomies, :page_title, :text
  end
end
