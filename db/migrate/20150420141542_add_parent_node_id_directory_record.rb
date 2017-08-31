class AddParentNodeIdDirectoryRecord < ActiveRecord::Migration
  def change
    add_column :directory_records, :parent_node_id, :integer
  end
end
