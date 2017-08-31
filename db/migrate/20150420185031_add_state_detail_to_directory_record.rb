class AddStateDetailToDirectoryRecord < ActiveRecord::Migration
  def change
    add_column :directory_records, :state_detail_node_id, :integer
  end
end
