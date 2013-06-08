class Input < ActiveRecord::Base
  attr_accessible :name, :score, :task_id
  belongs_to :task
end
