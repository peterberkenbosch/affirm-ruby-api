require "spec_helper"

RSpec.describe Affirm::Client, ".authorize" do
  let(:checkout_id) { "P08NWT3Z84P58GZS" }
  let(:payload) { read_json_fixture("authorize_transaction.json") }
  subject { Affirm::Client.new.authorize(checkout_id) }

  it "returns the Transaction object" do
    stub = stub_request(:post, "https://sandbox.affirm.com/api/v1/transactions")
      .with(headers: stub_headers)
      .with(basic_auth: stub_basic_auth)
      .with(body: payload.to_json)
      .to_return(read_http_fixture("authorize/success.http"))

    response = subject
    expect(stub).to have_been_requested
    expect(response).to be_a(Affirm::Struct::Transaction)
    expect(response.id).to eql "DVEP-FTQO"
  end

  context "when already authorized" do
    it "raises a RequestError" do
      stub = stub_request(:post, "https://sandbox.affirm.com/api/v1/transactions")
        .with(headers: stub_headers)
        .with(basic_auth: stub_basic_auth)
        .with(body: payload.to_json)
        .to_return(read_http_fixture("authorize/already_authorized.http"))

      expect { subject }.to raise_error(Affirm::RequestError, "The transaction has already been authorized.")
      expect(stub).to have_been_requested
    end
  end
end
