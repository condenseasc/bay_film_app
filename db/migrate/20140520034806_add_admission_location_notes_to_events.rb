class AddAdmissionLocationNotesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :admission, :string
    add_column :events, :location_notes, :string
  end
end
