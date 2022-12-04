class Api::V1::TransactionsController < ApplicationController
  def create
    transaction = Transaction.new(transaction_params)
    if transaction.save
      render json: TransactionSerializer.format_transaction(transaction), status: 201
    else
      # an error will be raised if a transaction cannot be successfully saved to the database
      # for any reason. This could be more dynamic but right now is covering all bases.
      render_error("400", "Bad request", "Error saving transaction")
    end
  end

  private

  def transaction_params
    {
      :points_available => params[:points],
      :points_initial => params[:points],
      # if a timestamp wasn't passed in, default to todays datetime
      :timestamp => params[:timestamp].nil? ? DateTime.now : params[:timestamp],
      :payer => params[:payer]
    }
  end
end