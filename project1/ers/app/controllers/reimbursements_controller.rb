# frozen_string_literal: true

class ReimbursementsController < ApplicationController
  include Authenticatable
  # GET /reimbursements
  def index
    Rails.logger.info('Index action: Called')
    if authorized? # Checks for user's admin role
      # Joins with user table to display user data alongside reimbursement data
      @reimbursement = Reimbursement.joins(:user).select('users.name, users.email, reimbursements.*')
      render json: @reimbursement, status: :ok # Returns all reimbursements from the database
      Rails.logger.info('Index action: Reimbursements retrieved successfully')
    else
      render json: { error: 'You are not authorized to view index' }, status: :unauthorized
      # Happens if user uses URL they arent meant to have as an employee
      Rails.logger.warn('Index action: Unauthorized access attempt')
    end
  end

  # POST /reimbursements
  def create
    Rails.logger.info('Create action: Called')
    data = JSON.parse(request.body.read) # Reads the body of the post request
    Rails.logger.debug("Create action: Data read: #{data.inspect}")
    data[:user_id] = current_user.id # Obtains user id from token, forces proper ownership
    # Assigns default values that the front end doesnt supply. This abstracts these values from the user
    data[:status] = 'Pending'
    Rails.logger.debug("Create action: Defaults applied: #{data.inspect}")
    @reimbursement = Reimbursement.new(data)
    if @reimbursement.user_id != current_user.id # If the data somehow fails to match the token, nothing will be entered
      render json: { error: 'You are not authorized to create this reimbursement' }, status: :unauthorized
      Rails.logger.warn("Create action: Unauthorized. user_id in data doesn't match token")
    elsif @reimbursement.save
      render json: { message: 'Reimbursement created' }, status: :created
      Rails.logger.info('Create action: Data successfully added to table') # If the data is saved to the database
    else # If user input is somehow very wrong
      render json: { message: 'Invalid reimbursement creation' }, status: :unprocessable_entity
      Rails.logger.error('Create action: Input was invalid')
    end
  end

  # GET /reimbursements
  def show
    Rails.logger.info('Show action: Called') # Retrieves a single reimbursement based on ID
    @reimbursement = Reimbursement.find(params[:id])
    if owns? || authorized?
      render json: @reimbursement, status: :ok
      Rails.logger.info('Show action: Reimbursement displayed')
    else
      render json: { error: "Unauthorized: You don't own this reimbursement" }, status: :unauthorized
      Rails.logger.warn('Show action: Unauthorized access')
    end
  end

  # GET /reimbursements/showuserreims
  def showUserReims
    # This retrieves all of a users reimbursements, without supplying an id. Works off of token. Used on homepage
    @reimbursement = Reimbursement.where(user_id: @current_user.id)
    render json: @reimbursement, status: :ok
    Rails.logger.info('ShowUserReims action: Reimbursements displayed')
  end

  # PUT/PATCH /reimbursements/:id
  def update
    Rails.logger.info('Update action: Called')
    @reimbursement = Reimbursement.find(params[:id])

    # Checks if either the user owns the specified reimbursement, if they're an admin. Only one of those needs to be t
    if owns? || authorized?
      Rails.logger.info('Update action: Authorized')
      if @reimbursement.update(JSON.parse(request.body.read))
        render json: { message: 'Reimbursement updated' }, status: :ok
        Rails.logger.info('Update action: Reimbursement updated')
      else
        render @reimbursement.errors, status: :unprocessable_entity # If update somehow fails
        Rails.logger.error('Update action: Update could not be applied to the database')
      end
    else
      render json: { error: 'You are not authorized to update this reimbursement' }, status: :unauthorized
      Rails.logger.warn('Update action: User does not own or have admin privileges')
    end
  end

  # Delete /reimbursements/:id
  def delete
    Rails.logger.info('Delete Action: Called')
    @reimbursement = Reimbursement.find(params[:id])
    # Checks if either the user owns the specified reimbursement, if they're an admin. Only one of those needs to be t
    if owns? || authorized?
      Rails.logger.info('Delete Action: Authorized')
      @reimbursement.destroy
      head :ok
      Rails.logger.info('Delete Action: Reimbursement deleted from database')
    else
      render json: { error: 'You are not authorized to delete this reimbursement' }, status: :unauthorized
      Rails.logger.warn('Delete Action: User does not own or have admin privileges')
    end
  end

  # Compares user supplied ID with their actual ID from token, checks for ownership
  def owns?
    if @reimbursement.user_id == @current_user.id
      Rails.logger.info('Ownership check: User owns chosen reimbursement')
      true
    else
      Rails.logger.info('Ownership check: User does not own chosen reimbursement')
      false
    end
  end
end
