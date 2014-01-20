class AddSeriesRefToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :series, index: true
  end
end
