class Api::V1::PointsController < ApplicationController
  def update
    if Transaction.sufficient_points?(params[:points])
      render json: Transaction.spend_points(params[:points]), status: 200
    else
      render_error("400", "Bad request", "Insufficient balance to redeem this request")
    end
  end

  def index
    render json: Transaction.get_points
  end
end