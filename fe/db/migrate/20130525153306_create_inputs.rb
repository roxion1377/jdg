class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.integer :task_id
      t.string :name
      t.integer :score

      t.timestamps
    end
  end
end
