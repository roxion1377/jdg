class CreateContestTasks < ActiveRecord::Migration
  def change
    create_table :contest_tasks do |t|
      t.integer :contest_id
      t.integer :task_id
      t.string :serial
      t.string :key

      t.timestamps
    end
  end
end
