class CreateEventsSeriesJoinTable < ActiveRecord::Migration
  def change
    create_table :events_series, id: false do |t|
      t.integer :event_id
      t.integer :series_id
    end
  end
end