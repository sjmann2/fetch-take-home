class User < ApplicationRecord
  has_many :transactions
  validates_presence_of :points
  validates_numericality_of :points
end
