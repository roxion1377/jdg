class Detail < ActiveRecord::Base
  attr_accessible :input, :memory, :output, :result_id, :state, :time
  belongs_to :result
  belongs_to :state
end
