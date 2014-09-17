class RenameEventColumns < ActiveRecord::Migration
  def change
    rename_column :events, :location_notes, :location_note
    rename_column :events, :show_notes, :announcement
    rename_column :events, :show_credits, :short_credit
    add_column :events, :full_credits, :text
  end
end
