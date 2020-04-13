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
end
