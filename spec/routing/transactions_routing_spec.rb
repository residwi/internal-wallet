require "rails_helper"

RSpec.describe TransactionsController, type: :routing do
  describe "routing" do
    it "routes to #transfer" do
      expect(post: "/transactions/transfer").to route_to("transactions#transfer")
    end

    it "routes to #deposit" do
      expect(post: "/transactions/deposit").to route_to("transactions#deposit")
    end

    it "routes to #withdraw" do
      expect(post: "/transactions/withdraw").to route_to("transactions#withdraw")
    end
  end
end
