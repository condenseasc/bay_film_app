class AddVenueRefToSeries < ActiveRecord::Migration
  def change
    add_reference :series, :venue, index: true
  end
end
