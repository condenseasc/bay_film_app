class RemoveCapsule < ActiveRecord::Migration
  def change
    remove_index :events, name: :index_events_on_capsule_id
    remove_index :series, name: :index_series_on_capsule_id

    drop_table :capsules
  end
end
