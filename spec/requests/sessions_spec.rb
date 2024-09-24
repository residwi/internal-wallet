require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "POST /sign_in" do
    context "when valid credentials" do
      it "creates a new session" do
        user = create :user

        post "/sign_in", params: { username: user.username, password: user.password }


        expected_session = user.sessions.first
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["token"]).to eq(expected_session.signed_id)
      end
    end

    context "when invalid credentials" do
      it "does not create a new session" do
        user = create :user

        post "/sign_in", params: { username: user.username, password: "wrong_password" }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq("The username or password is incorrect")
      end
    end
  end

  describe "DELETE /sign_out" do
    context "when valid token" do
      it "destroys the session" do
        user = create :user
        session = create :session, user: user

        delete "/sign_out", headers: { "Authorization" => "Bearer #{session.signed_id}" }

        expect(response).to have_http_status(:no_content)
      end
    end

    context "when invalid token" do
      it "does not destroy the session" do
        delete "/sign_out", headers: { "Authorization" => "Bearer invalid_token" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
