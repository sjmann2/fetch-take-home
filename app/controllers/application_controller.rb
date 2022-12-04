class ApplicationController < ActionController::API

  private

  def render_error(status, title, detail)
    error = ErrorSerializer.new(status, title, detail)
    render json: error.serialized_message, status: status.to_i
  end
end
