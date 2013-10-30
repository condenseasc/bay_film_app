class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.text :description
      t.string :website
      t.string :street_address
      t.string :city

      t.timestamps
    end
  end
end
