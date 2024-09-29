module LatestStockPrice
  class Client
    def initialize(url:, api_key:)
      @connection = create_connection(url: url, api_key: api_key)
    end

    def price(symbol)
      response = price_all
      response.stock_price(stock_symbol: symbol)
    end

    def price_all
      response = @connection.get("/any")
      raise ClientError.new(response.body) unless response.status == 200

      LatestStockPrice::Model::Response.new(response.body)
    end

    private

    def create_connection(url:, api_key:)
      options = {
        url: url,
        headers: {
          "x-rapidapi-key": api_key,
          "x-rapidapi-host": "latest-stock-price.p.rapidapi.com"
        }
      }

      Faraday.new(options)
    end
  end
end
