require_relative './json_web_token'

module Authenticatable
  extend ActiveSupport::Concern

  def authorized? # Checks if the current user has the admin role in their record in the database
    if @current_user.role == 'admin' # 'admin' and 'employee' should be the only possible roles
      Rails.logger.info("Authorization: User has admin permissions")
      return true
    end
  end

  included do # This runs the authenticate_request! method each time the controller that includes this module is used at all
    before_action :authenticate_request!
    attr_reader :current_user
  end

  private

  def authenticate_request! # This runs with each HTTP request that requires a token. Which is everything except creating an account and logging in
    Rails.logger.debug("Authentication: Token: #{token}")
    Rails.logger.info("Authentication: Authenticating token")
    token_data = JsonWebToken.decode(token) # Decodes token and obtains user ID
    Rails.logger.debug("Authentication: Current user: #{token_data.inspect}")
    if token_data == "Invalid Token"
      render json: { error: 'Not Authorized' }, status: 401
    elsif token_data == "Expired Token"
      render json: { error: 'Token is expired. Please login again.' }, status: 403
    else
      @current_user = User.find(token_data['user_id'])
    end
  end

  def token # Obtains the token from the request's authorization header. Bearer token
    request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?
  end

end
