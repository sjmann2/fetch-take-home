class Transaction < ApplicationRecord
  validates_presence_of :payer, :points_initial, :points_available
  validates_numericality_of :points_initial, :points_available

  def self.spend_points(points_to_redeem)
    ##
    # Redeem points, using oldest transactions first.
    # Returns an array of the payers who fulfilled the request and the points they spent.
    response = Hash.new(0)
    # grabbing transactions that have available points and ordering by oldest first
    Transaction.where("points_available > 0").order(:timestamp).map do |transaction|
      # Handle case where transaction has more points than needed
      # - just use the points needed instead of all the transaction's points
      if transaction.points_available > points_to_redeem
        points_redeemed = points_to_redeem
      else
        points_redeemed = transaction.points_available
      end
      # updating the transaction to account for the points spent
      transaction.update!(points_available: transaction.points_available - points_redeemed)
      response[transaction.payer] -= points_redeemed
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
    ##
    # Return True if there are enough points in the database to fulfill this request
    points_to_redeem < Transaction.where("points_available > 0").sum(:points_available)
  end


  def self.get_points
    ##
    # Return a hash of payer to the total available points for each payer
    Transaction.group(:payer).sum(:points_available)
  end
end