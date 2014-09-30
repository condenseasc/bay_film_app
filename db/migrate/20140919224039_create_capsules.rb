class CreateCapsules < ActiveRecord::Migration
  def change
    create_table :capsules do |t|
      t.text :title
      t.text :supertitle
      t.text :subtitle
      t.text :callout
      t.text :body
      t.text :footer
      t.text :url
      t.hstore :admission
      t.references :event, index: true
      t.references :series, index: true

      t.timestamps
    end
  end
end
