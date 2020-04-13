module Affirm
  module TestingSupport
    module HttpResponses
      def read_http_fixture(name)
        File.read(File.join(File.dirname(__FILE__), "fixtures.http", name))
      end

      def read_json_fixture(name)
        JSON.parse(File.read(File.join(File.dirname(__FILE__), "fixtures.json", name)))
      end
    end
  end
end
