module Affirm
  module TestingSupport
    module HttpResponses
      def stub_headers
        {
          "Accept" => "application/json",
          "Content-type" => "application/json",
          "User-Agent" => /^Affirm\/#{Affirm::VERSION} Ruby\/#{RUBY_VERSION} OpenSSL\/.*$/
        }
      end

      def stub_basic_auth
        [
          Affirm.config.public_api_key,
          Affirm.config.private_api_key
        ]
      end

      def read_http_fixture(name)
        File.read(File.join(File.dirname(__FILE__), "fixtures.http", name))
      end

      def read_json_fixture(name)
        JSON.parse(File.read(File.join(File.dirname(__FILE__), "fixtures.json", name)))
      end
    end
  end
end
