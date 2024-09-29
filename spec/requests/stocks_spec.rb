require "rails_helper"

RSpec.describe "Stocks", type: :request do
  let!(:source_wallet) { create :wallet, :for_user, :with_balance, balance: 100000 }
  let!(:source_user_session) { create :session, user: source_wallet.walletable }

  let(:valid_headers) {
    { "Authorization" => "Bearer #{source_user_session.token}" }
  }

  describe "GET /index" do
    it "returns a successful response" do
      get api_stocks_path, headers: valid_headers, as: :json

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns a successful response" do
      get api_stock_path("HDFCBANK"), headers: valid_headers, as: :json

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /buy" do
    context "with valid parameters" do
      it "buys the stock successfully" do
        valid_params = {
          symbol: "HDFCBANK",
          quantity: 1
        }

        post api_stocks_buy_path,
          params: valid_params, headers: valid_headers, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("Buy stock successful")
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid stock symbol" do
      it "does not create a new transaction" do
        invalid_params = {
          symbol: "stub-invalid-symbol",
          quantity: 0
        }

        post api_stocks_buy_path,
          params: invalid_params, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with insufficient balance" do
      it "does not create a new transaction" do
        valid_params = {
          symbol: "HDFCBANK",
          quantity: 999
        }

        post api_stocks_buy_path,
          params: valid_params, headers: valid_headers, as: :json

        error_response = JSON.parse(response.body)["errors"]
        expect(response).to have_http_status(:unprocessable_entity)
        expect(error_response["source_wallet"].first).to eq("Insufficient balance")
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end
end
