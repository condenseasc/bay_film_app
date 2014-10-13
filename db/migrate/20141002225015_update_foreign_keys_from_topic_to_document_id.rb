class UpdateForeignKeysFromTopicToDocumentId < ActiveRecord::Migration
  def change
    rename_column :events, :topic_id, :document_id
    rename_column :calendars, :topic_id, :document_id
  end
end
