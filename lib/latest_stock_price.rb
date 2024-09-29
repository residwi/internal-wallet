require "latest_stock_price/client"
require "latest_stock_price/model/response"

module LatestStockPrice
  class << self
    def new(api_host:, api_key:)
      url = "https://#{api_host}"

      LatestStockPrice::Client.new(url: url, api_key: api_key)
    end
  end
end
