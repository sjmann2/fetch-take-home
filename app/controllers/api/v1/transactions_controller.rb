class Api::V1::TransactionsController < ApplicationController
  def create
    transaction = Transaction.new(transaction_params)
    if transaction.save
      render json: TransactionSerializer.format_transaction(transaction), status: 201
    else
      render_error("400", "Bad request", "Error saving transaction")
    end
  end

  private

  def transaction_params
    {
      :points_available => params[:points],
      :points_initial => params[:points],
      :timestamp => params[:timestamp].nil? ? DateTime.now : params[:timestamp],
      :payer => params[:payer]
    }
  end
end