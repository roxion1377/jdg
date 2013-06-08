class Task < ActiveRecord::Base
  attr_accessible :body, :judge_type, :mle, :name, :tle
  belongs_to :contest
  has_many :contest_tasks
  has_many :results
  has_many :inputs

  validates :judge_type, :numericality => {:only_integer=>true}
  validates :mle, :numericality => {:only_integer=>true}
  validates :tle, :numericality => {:only_integer=>true}
  validates :name, :presence=>true
end
