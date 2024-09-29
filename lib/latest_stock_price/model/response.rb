module LatestStockPrice
  module Model
    class Response
      def initialize(response_json)
        @response_json = response_json
      end

      def json
        @json = JSON.parse(@response_json, symbolize_names: true)
      end

      def stock_price(stock_symbol:)
        stock = json.find { |res| res[:symbol] == stock_symbol }
        stock[:lastPrice]
      end
    end
  end
end
