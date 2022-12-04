class Transaction < ApplicationRecord
  validates_presence_of :payer, :points_initial, :points_available
  validates_numericality_of :points_initial, :points_available

  def self.spend_points(points_to_redeem)
    response = Hash.new(0)
    # grabbing transactions that have available points and ordering by oldest first
    Transaction.where("points_available > 0").order(:timestamp).map do |transaction|
      # if the transaction has more points available than requested, points redeemed is equal to the points requested
      if transaction.points_available > points_to_redeem
        points_redeemed = points_to_redeem
      else
      # otherwise, points redeemed is equal to the amount of points available in that transaction
        points_redeemed = transaction.points_available
      end
      # updating the transaction to account for the points spent
      transaction.update!(points_available: transaction.points_available - points_redeemed)
      # associating the payer with the amount of points spent
      response[transaction.payer] -= points_redeemed
      # subtract points redeemed from the total amount requested
      points_to_redeem -= points_redeemed
      #once points requested is at zero stop the cycle
      if points_to_redeem.zero?
        break
      end
    end
    # create a new transaction with the total amount of points subtracted from the payer, return payer, points
    response.map do |payer, points|
      Transaction.create!(payer: payer, points_initial: -points, points_available: 0, timestamp: DateTime.now)
      {:payer => payer, :points => points}
    end
  end

  def self.sufficient_points?(points_to_redeem)
    # check if there are enough points to redeem the amount of points requested
    points_to_redeem < Transaction.where("points_available > 0").sum(:points_available)
  end


  def self.get_points
    Transaction.group(:payer).sum(:points_available)
  end
end