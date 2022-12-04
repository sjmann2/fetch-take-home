class TransactionSerializer
  def self.format_transaction(transaction)
    {
      data: {
          id: transaction.id,
          type: "transaction",
          attributes: {
              payer: transaction.payer,
              points: transaction.points_initial,
              timestamp: transaction.timestamp
          }
      }
  }
  end
end
