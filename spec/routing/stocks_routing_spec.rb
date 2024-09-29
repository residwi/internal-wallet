require "rails_helper"

RSpec.describe Api::StocksController, type: :routing do
  describe "routing" do
    before do
      Rails.application.config.rapid_api.api_key = ""
      Rails.application.config.rapid_api.api_host = ""
    end

    it "routes to #index" do
      expect(get: "/api/stocks").to route_to("api/stocks#index")
    end

    it "routes to #show" do
      expect(get: "/api/stocks/AAPL").to route_to("api/stocks#show", symbol: "AAPL")
    end

    it "routes to #buy" do
      expect(post: "/api/stocks/buy").to route_to("api/stocks#buy")
    end
  end
end
