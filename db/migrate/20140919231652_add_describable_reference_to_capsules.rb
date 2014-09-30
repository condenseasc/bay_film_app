class AddDescribableReferenceToCapsules < ActiveRecord::Migration
  def change
    add_reference :capsules, :describable, polymorphic: true, index: true
  end
end
