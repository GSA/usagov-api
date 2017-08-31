class CreateDirectoryRecords < ActiveRecord::Migration
  def change
    create_table :directory_records do |t|
      t.integer :node_id
      t.string :title
      t.string :language
      t.string :alpha_order_name
      t.string :street_one
      t.string :street_two
      t.string :city
      t.string :state
      t.string :zip
      t.text :contact_links
      t.text :description
      t.string :directory_type
      t.string :donated_money
      t.string :government_branch
      t.string :phone_number
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :directory_record_sites do |t|
      t.integer :directory_record_id
      t.integer :site_id
    end

  end
end
