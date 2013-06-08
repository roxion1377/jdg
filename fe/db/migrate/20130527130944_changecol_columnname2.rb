class ChangecolColumnname2 < ActiveRecord::Migration
  def up
    rename_column(:states, :state, :state_name)
  end

  def down
  end
end
