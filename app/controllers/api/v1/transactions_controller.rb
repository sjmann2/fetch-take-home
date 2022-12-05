class Api::V1::TransactionsController < ApplicationController
  def create
    ##
    # Create a new transaction. 
    # Returns a 201 status code if successful, or a 400 status code if the request is invalid.
    transaction = Transaction.new(transaction_params)
    if transaction.save
      render json: TransactionSerializer.format_transaction(transaction), status: 201
    else
      # an error will be raised if a transaction cannot be successfully saved to the database
      # for any reason, including invalid parameters.
      render_error("400", "Bad request", "Error saving transaction")
    end
  end

  private

  def transaction_params
    ##
    # Transform the request params into the fields needed for a Transaction record
    {
      # Always initialize points_available and points_initial to the request params points
      :points_available => params[:points],
      :points_initial => params[:points],
      # if a timestamp wasn't passed in, default to todays datetime
      :timestamp => params[:timestamp].nil? ? DateTime.now : params[:timestamp],
      :payer => params[:payer]
    }
  end
end