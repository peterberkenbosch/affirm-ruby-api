require "spec_helper"

RSpec.describe Affirm::TestingSupport::HttpResponses do
  describe "#read_http_fixture" do
    let(:fixture_name) { "404_not_found.http" }
    it "will return the http fixture by name" do
      expect(read_http_fixture(fixture_name)).to_not be_empty
    end
  end

  describe "#read_json_fixture" do
    let(:fixture_name) { "authorize_transaction.json" }
    it "will return the json fixture by name" do
      expect(read_json_fixture(fixture_name)).to_not be_empty
    end
  end

  describe "stub_headers" do
    it "will return default headers to match with stubbing the request" do
      stubbed_headers = {
        "Accept" => "application/json",
        "Content-type" => "application/json",
        "User-Agent" => /^Affirm\/#{Affirm::VERSION} Ruby\/#{RUBY_VERSION} OpenSSL\/.*$/
      }
      expect(stub_headers).to eql stubbed_headers
    end
  end

  describe "stub_basic_auth" do
    it "will return basic_auth array to match with stubbing the request" do
      expect(stub_basic_auth).to eql [Affirm.config.public_api_key, Affirm.config.private_api_key]
    end
  end
end
