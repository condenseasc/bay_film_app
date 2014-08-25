class CreateStills < ActiveRecord::Migration
  def change
    create_table :stills do |t|
      t.text :alt
      t.attachment :image
    end
  end
end
