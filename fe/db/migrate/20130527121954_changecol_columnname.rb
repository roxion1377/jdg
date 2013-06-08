class ChangecolColumnname < ActiveRecord::Migration
  def up
    rename_column(:details, :state, :state_id)
    rename_column(:results, :state, :state_id)
  end

  def down
  end
end
