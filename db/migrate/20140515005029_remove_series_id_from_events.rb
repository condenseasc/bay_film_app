class RemoveSeriesIdFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :series_id, :integer
  end
end
