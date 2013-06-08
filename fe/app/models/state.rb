class State < ActiveRecord::Base
  attr_accessible :state_name
  has_many :details
  has_many :results
#  belongs_to :result
end
