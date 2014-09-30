class ChangeEventColumnNames < ActiveRecord::Migration
  def change
    rename_column :events, :announcement, :callout
    rename_column :events, :short_credit, :subtitle
    rename_column :events, :full_credits, :footer
    rename_column :events, :description, :body

    remove_column :events, :admission, :string
    add_column :events, :admission, :hstore

    add_column :events, :supertitle, :text
    change_column :events, :subtitle, :text
    change_column :events, :title, :text
    change_column :events, :url, :text
    remove_column :events, :time, :datetime
  end
end