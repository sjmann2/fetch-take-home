class Api::V1::TransactionsController < ApplicationController
  def create
    transaction = Transaction.new(transaction_params)
    if transaction.save
      render json: TransactionSerializer.format_transaction(transaction), status: 201
    else
      error = ErrorSerializer.new("400", "Bad request", transaction.errors.full_messages)
      render json: error.serialized_message, status: 400
    end
  end

  private

  def transaction_params
    params.permit(:payer, :points, :timestamp)
  end
end