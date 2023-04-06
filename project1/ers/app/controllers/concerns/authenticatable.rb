require_relative './json_web_token'

module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request!
    attr_reader :current_user
  end

  private

  def authenticate_request!
    token_data = JsonWebToken.decode(token)
    puts "Authenticating token"
    puts "Current user: #{token_data.inspect}"
    if token_data == "Invalid Token"
      render json: { error: 'Not Authorized' }, status: 401
    elsif token_data == "Expired Token"
      render json: { error: 'Token is expired. Please login again.' }, status: 401
      # render json: { error: 'You are not allowed to perform this action' }, status: 403
    else
      @current_user = User.find(token_data['user_id'])
      # render json: { error: 'Not Authorized' }, status: 401 unless current_user
    end
  end

  def token
    request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?
  end
end
