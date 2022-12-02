class Api::V1::PointsController < ApplicationController
  def update
    render json: Transaction.spend_points(params[:points]), status: 200
  end

  def index
  
  end
end