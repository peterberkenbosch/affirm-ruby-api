require "spec_helper"

RSpec.describe Affirm::Client, ".authorize" do
  let(:transaction_id) { "DVEP-FTQO" }
  subject { Affirm::Client.new.capture(transaction_id) }

  it "Captures the payment and creates a transaction event" do
    stub = stub_request(:post, "https://sandbox.affirm.com/api/v1/transactions/#{transaction_id}/capture")
      .with(headers: stub_headers)
      .with(basic_auth: stub_basic_auth)
      .to_return(read_http_fixture("capture/success.http"))

    response = subject
    expect(stub).to have_been_requested
    expect(response).to be_a(Affirm::Struct::Transaction::Event)
    expect(response.id).to eql "U4ABBRQG5M01JDZ6"
    expect(response.amount).to eql 25000
    expect(response.type).to eql "capture"
  end

  context "when already captured" do
    it "raises a RequestError" do
      stub = stub_request(:post, "https://sandbox.affirm.com/api/v1/transactions/#{transaction_id}/capture")
        .with(headers: stub_headers)
        .with(basic_auth: stub_basic_auth)
        .to_return(read_http_fixture("capture/already_captured.http"))
      expect { subject }.to raise_error(Affirm::RequestError, "The transaction has already been captured.")
      expect(stub).to have_been_requested
    end
  end
end
