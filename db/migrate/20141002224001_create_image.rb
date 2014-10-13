class CreateImage < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.text :alt
      t.text :title
      t.text :source_url
      t.has_attached_file :asset
      t.references :imageable, polymorphic: true, index: true
    end
  end
end
