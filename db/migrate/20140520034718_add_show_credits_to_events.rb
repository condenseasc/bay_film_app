class AddShowCreditsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :show_credits, :string
  end
end
