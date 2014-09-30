class RemoveCapsuleReferenceFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :capsule_id, :integer
  end
end
