class RemoveFieldsFromStateDetails < ActiveRecord::Migration
  def change
  	remove_column :state_details, :language_text, :string
  	remove_column :state_details, :language_url, :string
  end
end
