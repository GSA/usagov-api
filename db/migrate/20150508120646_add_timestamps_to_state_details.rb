class AddTimestampsToStateDetails < ActiveRecord::Migration
  def change
    add_column :state_details, :created_at, :datetime
    add_column :state_details, :updated_at, :datetime
  end
end
