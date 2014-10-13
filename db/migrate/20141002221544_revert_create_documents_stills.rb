require_relative '20141002205540_create_documents_stills'

class RevertCreateDocumentsStills < ActiveRecord::Migration
  def change
    revert CreateDocumentsStills
  end
end
