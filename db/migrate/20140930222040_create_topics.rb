class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.text :title
      t.text :supertitle
      t.text :subtitle
      t.text :callout
      t.text :body
      t.text :footer
      t.text :url

      t.timestamps
    end
  end
end