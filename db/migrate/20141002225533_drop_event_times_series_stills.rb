class DropEventTimesSeriesStills < ActiveRecord::Migration
  def change
    remove_index :series, :venue_id
    drop_table :event_times
    drop_table :series
    drop_table :stills
  end
end
