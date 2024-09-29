require "rails_helper"

RSpec.describe Api::TransactionsController, type: :routing do
  describe "routing" do
    it "routes to #transfer" do
      expect(post: "/api/transactions/transfer").to route_to("api/transactions#transfer")
    end

    it "routes to #deposit" do
      expect(post: "/api/transactions/deposit").to route_to("api/transactions#deposit")
    end

    it "routes to #withdraw" do
      expect(post: "/api/transactions/withdraw").to route_to("api/transactions#withdraw")
    end
  end
end
