class ContestTask < ActiveRecord::Base
  attr_accessible :contest_id, :serial, :task_id
  belongs_to :contest
  belongs_to :task
  validates :contest_id, :numericality => {:only_integer=>true}
  validates :task_id, :numericality => {:only_integer=>true}
  validates :key, :uniqueness => true

  validate 
end
