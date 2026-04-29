class ApplicationController < ActionController::API
  include ApiResponseHandler
  include ApiExceptionHandler
end
