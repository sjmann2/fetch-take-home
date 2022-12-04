class Transaction < ApplicationRecord
  validates_presence_of :payer, :points
  validates_numericality_of :points

  def self.spend_points(total_points)
    response = Hash.new(0)
    Transaction.order(:timestamp).map do |transaction|
      if transaction.points > total_points
        response[transaction.payer]  -= total_points
        Transaction.create!(payer: transaction.payer, points: -total_points, timestamp: DateTime.now)

        total_points = 0
      else
        Transaction.create!(payer: transaction.payer, points: -transaction.points, timestamp: DateTime.now)
        response[transaction.payer] -= transaction.points
        total_points -= transaction.points
      end

      if total_points.zero?
        break
      end
    end
    response.map do |payer, points|
      {:payer => payer, :points => points}
    end
    #possibly add column to transactions that is "points spent"--prevent re spending points
  end

  def self.sufficient_points?(points_redeemed)
    points_redeemed < Transaction.sum(:points)
  end


  def self.get_points
    Transaction.group(:payer).sum(:points)
  end
end