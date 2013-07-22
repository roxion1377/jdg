# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
State.delete_all
State.connection.execute("delete from sqlite_sequence where name='states'")
State.create!(:state_name=>"Compiling")
State.create!(:state_name=>"CompleError")
State.create!(:state_name=>"Running")
State.create!(:state_name=>"MemoryLimitExceeded")
State.create!(:state_name=>"TimeLimitExceeded")
State.create!(:state_name=>"RuntimeError")
State.create!(:state_name=>"WrongAnswer")
State.create!(:state_name=>"Accepted")
State.create!(:state_name=>"Waiting")

User.delete_all

f = open("db/users.txt")
while l = f.gets
  name,pass = l.split(" ")
  User.create!(:name => name, :password => pass, :password_confirmation => pass)
end
