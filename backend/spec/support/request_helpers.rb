module RequestHelpers
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def json_data
    json_response[:data]
  end

  def json_errors
    json_response[:errors]
  end

  def json_message
    json_response[:message]
  end

  def json_success?
    json_response[:success]
  end

  def json_headers
    { "Content-Type" => "application/json", "Accept" => "application/json" }
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
