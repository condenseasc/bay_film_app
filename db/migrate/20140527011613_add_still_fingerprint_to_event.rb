class AddStillFingerprintToEvent < ActiveRecord::Migration
  def change
    add_column :events, :still_fingerprint, :string
  end
end
