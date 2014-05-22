class AddAbbreviationToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :abbreviation, :string
  end
end
