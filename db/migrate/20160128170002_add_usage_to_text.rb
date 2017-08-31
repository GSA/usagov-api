class AddUsageToText < ActiveRecord::Migration
  def change
    add_column :text_assets, :for_use_by, :string
  end
end
