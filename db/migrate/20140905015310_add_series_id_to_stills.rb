class AddSeriesIdToStills < ActiveRecord::Migration
  def change
    add_column :stills, :series_id, :integer
  end
end
