module ApiResponseHandler
  extend ActiveSupport::Concern

  def render_success(data = nil, message = "Success", status = :ok)
    return head(:no_content) if status == :no_content

    render json: {
      success: true,
      message: message,
      data: data
    }, status: status
  end

  def render_error(errors, message = "Error", status = :unprocessable_entity)
    render json: {
      success: false,
      message: message,
      errors: errors
    }, status: status
  end
end
