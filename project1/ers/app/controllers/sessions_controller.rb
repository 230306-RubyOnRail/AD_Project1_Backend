require_relative './concerns/json_web_token'

class SessionsController < ApplicationController

  def create # Creates a session, which gives a user a token that provides them access after they provide credentials
    Rails.logger.debug("Session: Validating Credentials")
    credentials = JSON.parse(request.body.read)
    user = User.where(email: credentials['email']).first
    if user&.authenticate(credentials['password']) # If user input matches credentials in the database, they are given a token that they need to give back with each following request
      render json: { token: JsonWebToken.encode(user_id: user.id), name: user.name, email: user.email, role: user.role}, status: :created
      Rails.logger.info("Session: Created")
    else
      render :json => { error: 'Invalid login credentials' }, status: :unauthorized
      Rails.logger.warn("Session: Invalid credentials")
    end
  end
end
