class AddAttachmentStillToImages < ActiveRecord::Migration
  def self.up
    change_table :images do |t|
      t.attachment :still
    end
  end

  def self.down
    remove_attachment :images, :still
  end
end
