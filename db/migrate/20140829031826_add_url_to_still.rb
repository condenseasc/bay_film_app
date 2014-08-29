class AddUrlToStill < ActiveRecord::Migration
  def change
    add_column :stills, :url, :text
  end
end
