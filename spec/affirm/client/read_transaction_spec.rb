require "spec_helper"

RSpec.describe Affirm::Client, ".read_transaction" do
  let(:transaction_id) { "DVEP-FTQO" }
  subject { Affirm::Client.new.read_transaction(transaction_id) }

  it "return the transaction without events by default" do
    stub = stub_request(:get, "https://sandbox.affirm.com/api/v1/transactions/#{transaction_id}")
      .with(headers: stub_headers)
      .with(basic_auth: stub_basic_auth)
      .to_return(read_http_fixture("get_transaction/success_captured.http"))

    response = subject
    expect(stub).to have_been_requested
    expect(response).to be_a(Affirm::Struct::Transaction)
    expect(response.id).to eql transaction_id
    expect(response.events).to be_empty
    expect(response.status).to eql "captured"
  end

  context "with expand parameter present" do
    let(:transaction_id) { "LS-4BSY-SV6E" }
    subject { Affirm::Client.new.read_transaction(transaction_id, "events") }

    it "returns the transaction expanded with the passed in param" do
      stub = stub_request(:get, "https://sandbox.affirm.com/api/v1/transactions/#{transaction_id}?expand=events")
        .with(headers: stub_headers)
        .with(basic_auth: stub_basic_auth)
        .to_return(read_http_fixture("get_transaction/success_with_multiple_events.http"))

      response = subject
      expect(stub).to have_been_requested
      expect(response).to be_a(Affirm::Struct::Transaction)
      expect(response.id).to eql transaction_id
      expect(response.events).to_not be_empty
      expect(response.status).to eql "voided"
    end
  end
end
