class ChangeDocumentForeignIds < ActiveRecord::Migration
  def change
    rename_column :calendars, :document_id, :summary_id
    rename_column :events, :document_id, :topic_id
  end
end
