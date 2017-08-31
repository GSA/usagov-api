class AddLanguage < ActiveRecord::Migration
  def change
    add_column :state_details, :language, :string
  end
end
