require_relative './concerns/json_web_token'

class SessionsController < ApplicationController

  def create
    credentials = JSON.parse(request.body.read)
    user = User.where(email: credentials['email']).first
    if user&.authenticate(credentials['password'])
      render json: { token: JsonWebToken.encode(user_id: user.id), name: user.name, email: user.email, role: user.role}, status: :created
    else
      render :json => { error: 'Invalid login credentials' }, status: :unauthorized
    end
  end
end
