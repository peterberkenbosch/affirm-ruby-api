require "spec_helper"

RSpec.describe Affirm::Struct::Transaction do
  describe "#provider" do
    context "when provider_id is 1" do
      let(:transaction) { Affirm::Struct::Transaction.new(provider_id: 1) }
      it "returns :affirm" do
        expect(transaction.provider).to eql :affirm
      end
    end

    context "when provider_id is 2" do
      let(:transaction) { Affirm::Struct::Transaction.new(provider_id: 2) }
      it "returns :katapult" do
        expect(transaction.provider).to eql :katapult
      end
    end

    context "when provider_id is nil" do
      let(:transaction) { Affirm::Struct::Transaction.new }
      it "returns nil" do
        expect(transaction.provider).to eql nil
      end
    end

    context "when provider_id is anything else" do
      let(:transaction) { Affirm::Struct::Transaction.new(provider_id: 99) }
      it "returns nil" do
        expect(transaction.provider).to eql nil
      end
    end
  end
end
