class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :venues, :website, :url
  end
end
