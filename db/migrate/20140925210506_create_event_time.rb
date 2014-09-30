class CreateEventTime < ActiveRecord::Migration
  def change
    create_table :event_times do |t|
      t.datetime :start, null: false
      t.references :event, index: true
      
      t.timestamps
    end
  end
end
