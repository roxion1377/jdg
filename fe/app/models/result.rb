class Result < ActiveRecord::Base
  attr_accessible :contest_id, :contest_task_id, :lang_id, :message, :state_id, :user_id, :score
  belongs_to :contest_task
  belongs_to :user
  belongs_to :state
  has_many :details
end
