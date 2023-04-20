# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    Rails.logger.debug('Users: Employee signup begun')
    user = User.new(JSON.parse(request.body.read))
    # Anyone who makes their own new account is forced to be an employee regardless of request body
    user[:role] = 'employee'
    if user.save
      render json: { user: }, status: :created
      Rails.logger.info('Users: Employee signed up')
    else
      render json: user.errors, status: :unprocessable_entity
      # If saving user to database fails, possibly due to bad user input
      Rails.logger.warn('Users: Invalid employee creation')
    end
  end
end
