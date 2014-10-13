class RemoveEventSeriesIndex < ActiveRecord::Migration
  def change
    remove_index :event_times, name: :index_event_times_on_event_id
    remove_index :stills, name: :index_stills_on_event_id
  end
end
