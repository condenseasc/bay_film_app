class RemoveEventReferenceSeriesReferenceFromCapsule < ActiveRecord::Migration
  def change
    remove_index :capsules, :event_id
    remove_index :capsules, :series_id
    remove_column :capsules, :event_id
    remove_column :capsules, :series_id
  end
end
