class Api::V1::TransactionsController < ApplicationController
  def create
    transaction = Transaction.new(transaction_params)
    if transaction.save
      render json: TransactionSerializer.format_transaction(transaction), status: 201
      # TODO Update this to not use serializer
    else
      render_error("400", "Bad request", transaction.errors.full_messages)
    end
  end

  private

  def transaction_params
    params.permit(:payer, :points, :timestamp)
  end
end