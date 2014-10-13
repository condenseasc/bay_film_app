class ChangeTopicsToDocuments < ActiveRecord::Migration
  def change
    rename_table :topics, :documents
  end
end
