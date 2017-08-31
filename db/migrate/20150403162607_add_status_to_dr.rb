class AddStatusToDr < ActiveRecord::Migration
  def change
    add_column :directory_records, :status, :string
  end
end
