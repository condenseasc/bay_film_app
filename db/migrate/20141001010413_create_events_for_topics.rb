class CreateEventsForTopics < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime    :time
      t.references  :topic

      t.timestamps
    end
  end
end
