class SessionsController < ApplicationController
  skip_before_action :authenticate, only: :create

  before_action :set_session, only: :destroy

  def create
    if user = User.authenticate_by(username: params[:username], password: params[:password])
      @session = Session.create!(user: user)

      render json: { token: @session.signed_id }, status: :created
    else
      render json: { error: "The username or password is incorrect" }, status: :unauthorized
    end
  end

  def destroy
    @session.destroy
  end

  private

  def set_session
    @session = Current.session
  end
end
