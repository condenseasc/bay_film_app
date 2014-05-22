class ChangeShowNotesDataType < ActiveRecord::Migration
  def change
    change_column :events, :show_notes, :text
  end
end
