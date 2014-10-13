class AddScrapedToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :scraped, :boolean
  end
end
