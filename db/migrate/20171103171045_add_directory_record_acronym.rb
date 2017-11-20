class AddDirectoryRecordAcronym < ActiveRecord::Migration
  def change
    add_column :directory_records, :acronym, :string
  end
end

#jkjk
# to add this to the database, run 'rake db:migrate'