class AddShowNotesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :show_notes, :string
  end
end
