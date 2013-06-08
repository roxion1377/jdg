class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.integer :memory
      t.integer :result_id
      t.integer :state
      t.integer :time
      t.string :input
      t.string :output

      t.timestamps
    end
  end
end
