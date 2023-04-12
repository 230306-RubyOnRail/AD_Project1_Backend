class UsersController < ApplicationController

  def create
    Rails.logger.debug("Users: Employee signup begun")
    user = User.new(JSON.parse(request.body.read))
    user[:role] = "employee" # Anyone who makes their own new account is forced to be an employee regardless of request body
    if user.save #
      render json: { user: user }, status: :created
      Rails.logger.info("Users: Employee signed up")
    else
      render json: user.errors, status: :unprocessable_entity
      Rails.logger.warn("Users: Invalid employee creation") # If saving user to database fails, possibly due to bad user input
    end
  end
end