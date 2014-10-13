class AddOptionsOnScrapedInDocument < ActiveRecord::Migration
  def change
    change_column :documents, :scraped, :boolean, default: false, null: false
  end
end
