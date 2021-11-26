# frozen_string_literal: true

module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def error_response(error, status = 401)
    render json: { message: error }, status: status
  end
end
