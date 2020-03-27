module Affirm
  class Error < StandardError
  end

  class RequestError < Error
    attr_reader :http_response

    def initialize(http_response)
      @http_response = http_response
      super(message_from(http_response))
    end

    private

    def message_from(http_response)
      return http_response if http_response.class == String
      content_type = http_response.header["Content-Type"]
      if content_type&.start_with?("application/json")
        JSON.parse(http_response.body)["message"]
      end
    end
  end

  class NotFoundError < RequestError
  end

  class AuthenticationError < RequestError
  end
end
