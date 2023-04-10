class UsersController < ApplicationController
  def createEmployee
    user = User.new(JSON.parse(request.body.read))
    user[:role] = "employee"
    if user.save
      render json: { user: user }, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def createAdmin
    user = User.new(JSON.parse(request.body.read))
    user[:role] = "admin"
    if user.save
      render json: { user: user }, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end
end