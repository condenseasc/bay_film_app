class AddUrlToSeries < ActiveRecord::Migration
  def change
    add_column :series, :url, :string
  end
end
