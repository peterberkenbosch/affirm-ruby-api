module Affirm
  class Client
    def initialize
      @version_strings = []
      add_version_string "Affirm/" << VERSION
      add_version_string "Ruby/" << RUBY_VERSION
      add_version_string OpenSSL::OPENSSL_VERSION.split(" ").slice(0, 2).join "/"
    end

    def user_agent_string
      @version_strings.join(" ")
    end

    # Start the 'store' checkout with Affirm.
    #
    # @see https://docs.affirm.com/affirm-developers/reference#checkout-store
    #
    # @param  [Hash] payload
    # @return <Struct::Checkout::Response>
    #
    # @raise  Affirm::RequestError
    def start_checkout_store(payload)
      response = http_call(:post, "checkout/store", nil, payload)
      Struct::Checkout::Response.new(response)
    end

    # Start the 'direct' checkout with Affirm.
    #
    # @see https://docs.affirm.com/affirm-developers/reference#checkout-direct
    #
    # @param  [Hash] payload
    # @return <Struct::Checkout::Response>
    #
    # @raise  Affirm::RequestError
    def start_checkout_direct(payload)
      response = http_call(:post, "checkout/direct", nil, payload)
      Struct::Checkout::Response.new(response)
    end

    # Fetch the checkout by checkout_id
    #
    # @see https://docs.affirm.com/affirm-developers/reference#checkout-read
    #
    # @param [String] checkout_id
    # @return <Struct::Checkout>
    #
    # @raise Affirm::RequestError
    def get_checkout(checkout_id)
      response = http_call(:get, :checkout, checkout_id)
      Struct::Checkout.new(response)
    end

    # Authorize the transaction
    #
    # @see https://docs.affirm.com/affirm-developers/reference#authorize
    #
    # @param [String] checkout_id
    # @return <Struct::Transaction>
    #
    # @raise Affirm::RequestError
    def authorize(checkout_id)
      response = http_call(:post, :transactions, nil, {transaction_id: checkout_id})
      Struct::Transaction.new(response)
    end

    # Captures the transaction
    #
    # @see https://docs.affirm.com/affirm-developers/reference#capture
    #
    # @param [String] transaction_id
    # @return <Struct::Transaction::Event>
    #
    # @raise Affirm::RequestError
    def capture(transaction_id)
      response = http_call(:post, "transactions/#{transaction_id}/capture")
      Struct::Transaction::Event.new(response)
    end

    # Get the transaction by transaction_id
    #
    # @see https://docs.affirm.com/affirm-developers/reference#read-transaction
    #
    # @param [String] transaction_id
    # @param [String] expand
    # @return <Struct::Transaction::Event>
    #
    # @raise Affirm::RequestError
    def read_transaction(transaction_id, expand = nil)
      transaction_path = "transactions/#{transaction_id}?expand=#{expand}" if expand
      transaction_path = "transactions/#{transaction_id}" unless expand
      response = http_call(:get, transaction_path)
      Struct::Transaction.new(response)
    end

    # Void the transaction
    #
    # @see https://docs.affirm.com/affirm-developers/reference#void-1
    #
    # @param [String] transaction_id
    # @return <Struct::Transaction::Event>
    #
    # @raise Affirm::RequestError
    def void(transaction_id)
      response = http_call(:post, "transactions/#{transaction_id}/void")
      Struct::Transaction::Event.new(response)
    end

    # Refunds the transaction
    #
    # @see https://docs.affirm.com/affirm-developers/reference#refund-1
    #
    # @param [String] transaction_id
    # @param [Integer] amount in cents to refund, when nil the total amount is refunded
    # @return <Struct::Transaction::Event>
    #
    # @raise Affirm::RequestError
    def refund(transaction_id, amount = nil)
      response = if amount
        http_call(:post, "transactions/#{transaction_id}/refund", nil, {amount: amount})
      else
        http_call(:post, "transactions/#{transaction_id}/refund")
      end
      Struct::Transaction::Event.new(response)
    end

    # Executes a request, validates and returns the response.
    #
    # @param  [String] http_method The HTTP method (:get, :post)
    # @param  [String] api_method The api method to call
    # @param  [String] id the optional id to be pasted in
    # @param  [Hash] an optional body to post to the endpoint
    # @return [Hash]
    # @raise  [RequestError]
    # @raise  [NotFoundError]
    # @raise  [AuthenticationFailed]
    def http_call(http_method, api_method, id = nil, body = {})
      version = "v2"

      # The Transaction api is actually the new API and replaces
      # the Charge api. However the api endpoint for Transactions
      # is set under a v1 version path.
      version = "v1" if (api_method == :transactions) || ((api_method.class == String) && api_method.start_with?("transactions"))

      path = "/api/#{version}/#{api_method}/#{id}".chomp("/")
      api_endpoint = Affirm.config.endpoint
      uri = URI.parse(api_endpoint)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.set_debug_output($stdout) if ENV["DEBUG"]

      case http_method
      when :get
        request = Net::HTTP::Get.new(path)
      when :post
        body.delete_if { |_k, v| v.nil? }
        request = Net::HTTP::Post.new(path)
        request.body = body.to_json
      else
        raise RequestError, "Invalid HTTP Method: #{http_method.to_s.upcase}"
      end
      request.basic_auth Affirm.config.public_api_key, Affirm.config.private_api_key

      request["Accept"] = "application/json"
      request["Content-Type"] = "application/json"
      request["User-Agent"] = user_agent_string

      begin
        response = http.request(request)
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
        Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        raise RequestError, e.message
      end

      http_code = response.code.to_i
      case http_code
      when 200, 201
        JSON.parse(response.body)
      when 400, 403
        # 400 - Bad request
        raise RequestError, response
      when 401
        # 401 - Unauthorized
        raise AuthenticationError, response
      when 404
        # 404 - Not found
        raise NotFoundError, response
      when 500, 502, 503, 504
        # 500, 502, 503, 504 - Server Errors
        raise Error, response
      end
    end

    private

    def add_version_string(version_string)
      @version_strings << version_string.gsub(/\s+/, "-")
    end
  end
end
