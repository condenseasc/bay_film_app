class AddEventRefToStills < ActiveRecord::Migration
  def change
    add_reference :stills, :event, index: true
  end
end
