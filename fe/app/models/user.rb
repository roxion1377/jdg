class User < ActiveRecord::Base
  attr_accessible :name, :password, :password_confirmation, :password_digest
  validates :name, presence: true, uniqueness: true
  has_secure_password
  has_many :results
end
