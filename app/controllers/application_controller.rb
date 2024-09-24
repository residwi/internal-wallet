class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  private

  def authenticate
    if session_record = authenticate_with_http_token { |token, _| Session.find_signed(token) }
      Current.session = session_record
    else
      request_http_token_authentication
    end
  end
end
