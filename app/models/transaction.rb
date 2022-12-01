class Transaction < ApplicationRecord
  validates_presence_of :payer, :points
  validates_numericality_of :points
end
