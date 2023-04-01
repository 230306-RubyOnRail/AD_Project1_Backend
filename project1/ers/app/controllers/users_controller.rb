class UsersController < ApplicationController
  def create
    user = User.new(JSON.parse(request.body.read))
    if user.save
      render json: { user: user }, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end
end
