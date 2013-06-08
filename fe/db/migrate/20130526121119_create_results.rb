class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :lang_id
      t.text :message
      t.integer :state
      t.integer :contest_task_id
      t.integer :user_id
      t.integer :contest_id

      t.timestamps
    end
  end
end
