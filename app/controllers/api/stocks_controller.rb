module Api
  class StocksController < ApplicationController
    before_action :set_latest_stock_price

    def index
      stocks = @latest_stock_price.price_all

      render json: stocks
    end

    def show
      stock = @latest_stock_price.price(params[:symbol])

      render json: stock
    end

    def buy
      stock_price = @latest_stock_price.price(params[:symbol])

      StockTransaction.buy!(
        source_wallet_id: Current.session.user.wallet.id,
        stock_name: params[:symbol],
        quantity: params[:quantity].to_i,
        stock_price: stock_price.to_f
      )
     render json: { message: "Buy stock successful" }
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.messages }, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unprocessable_entity
    rescue => e
      render json: { errors: e.message }, status: :internal_server_error
    end

    private

    def set_latest_stock_price
      options = {
        api_host: Rails.application.config.rapid_api.api_host,
        api_key: Rails.application.config.rapid_api.api_key
      }

      @latest_stock_price = LatestStockPrice.new(**options)
    end
  end
end
