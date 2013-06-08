class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string :name
      t.datetime :begin
      t.datetime :end

      t.timestamps
    end
  end
end
