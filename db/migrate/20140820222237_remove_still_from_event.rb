class RemoveStillFromEvent < ActiveRecord::Migration
  def change
    remove_column :events, :still_fingerprint, :string
    remove_column :events, :still_file_name, :string
    remove_column :events, :still_content_type, :string
    remove_column :events, :still_file_size, :integer
    remove_column :events, :still_updated_at, :datetime
  end
end