class Contest < ActiveRecord::Base
  attr_accessible :begin, :end, :name
  has_many :tasks
  has_many :contest_tasks
end
