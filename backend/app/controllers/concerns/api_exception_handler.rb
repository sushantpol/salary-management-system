module ApiExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_standard_error
    rescue_from ArgumentError, with: :handle_argument_error
    rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  end

  private

  def handle_record_not_found(exception)
    render_error(exception.message, "Resource not found", :not_found)
  end

  def handle_record_invalid(exception)
    render_error(exception.record.errors.to_hash, "Validation failed", :unprocessable_entity)
  end

  def handle_parameter_missing(exception)
    render_error(exception.message, "Bad request", :bad_request)
  end

  def handle_argument_error(exception)
    render_error(exception.message, "Invalid argument", :unprocessable_entity)
  end

  def handle_standard_error(exception)
    error_details = Rails.env.production? ? "An unexpected error occurred" : exception.message
    render_error(error_details, "Internal server error", :internal_server_error)
  end
end
