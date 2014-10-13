class DropEvents < ActiveRecord::Migration
  def up
    drop_table :events
  end
  def down
    create_table :events do |t|
      t.text     "title"
      t.text     "body"
      t.integer  "venue_id"
      t.text     "url"
      t.text     "callout"
      t.text     "subtitle"
      t.string   "location_note"
      t.text     "footer"
      t.hstore   "admission"
      t.text     "supertitle"

      t.timestamps
    end
  end
end
