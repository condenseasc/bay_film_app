class CreateDocumentsStills < ActiveRecord::Migration
  def change
    create_table :documents_stills do |t|
      t.integer :document_id
      t.integer :still_id
    end
  end
end
