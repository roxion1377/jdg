class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :tle
      t.integer :mle
      t.text :body
      t.integer :judge_type

      t.timestamps
    end
  end
end
