class AdminsController < ApplicationController
  include Authenticatable
  def create # This is in a separate controller so it can include Auth, this should only be called by an admin creating another admin account
    Rails.logger.debug("Users: Admin signup begun")
    if authorized? # Checks if the logged in user creating the account is an admin themselves
      user = User.new(JSON.parse(request.body.read)) # Admins are still a user, just like employees, they just have a role that gives extra permissions
      user[:role] = "admin" # If a logged in manager creates an admin account, role is forced to be admin regardless of request body
      if user.save
        render json: { user: user }, status: :created
        Rails.logger.info("Users: Admin signed up")
      else
        render json: user.errors, status: :unprocessable_entity
        Rails.logger.warn("Users: Invalid admin creation") # If saving to database fails, possibly due to bad user input
      end
    else
      render json: { error: 'You are not authorized to perform this action' }, status: :unauthorized
      Rails.logger.warn("Users: Unauthorized admin creation attempt")
    end
  end
end
