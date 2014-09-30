class ChangeSeriesColumns < ActiveRecord::Migration
  def change
    rename_column :series, :description, :body
    change_column :series, :title, :text
    change_column :series, :title, :text

    add_column :series, :supertitle, :text
    add_column :series, :subtitle, :text
    add_column :series, :callout, :text
    add_column :series, :footer, :text
  end
end
