class AddStillToEvent < ActiveRecord::Migration
  def self.up
    add_attachment :events, :still
  end

  def self.down
    remove_attachment :events, :still
  end
end
