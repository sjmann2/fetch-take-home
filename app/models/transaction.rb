class Transaction < ApplicationRecord
  belongs_to :user
  validates_presence_of :payer, :points
  validates_numericality_of :points
end
