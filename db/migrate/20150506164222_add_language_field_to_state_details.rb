class AddLanguageFieldToStateDetails < ActiveRecord::Migration
  def change
    add_column :state_details, :language_field, :string
  end
end
