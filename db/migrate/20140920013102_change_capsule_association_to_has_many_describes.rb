require_relative '20140919231652_add_describable_reference_to_capsules'

class ChangeCapsuleAssociationToHasManyDescribes < ActiveRecord::Migration
  def change
    revert AddDescribableReferenceToCapsules

    add_reference :events, :capsule, index: true
    add_reference :series, :capsule, index: true
  end
end
