class ReimbursementsController < ApplicationController
  include Authenticatable
  def index # GET /reimbursements
    Rails.logger.info("Index action: Called")
    if authorized? # Checks for user's admin role
      @reimbursement = Reimbursement.joins(:user).select('users.name, users.email, reimbursements.*') # Joins with user table to display user data alongside reimbursement data
      render json: @reimbursement, status: :ok # Returns all reimbursements from the database
      Rails.logger.info("Index action: Reimbursements retrieved successfully")
    else
      render json: { error: 'You are not authorized to view index' }, status: :unauthorized
      Rails.logger.warn("Index action: Unauthorized access attempt") # Happens if user uses URL they arent meant to have as an employee
    end
  end

  def create # POST /reimbursements
    Rails.logger.info("Create action: Called")
    data = JSON.parse(request.body.read) # Reads the body of the post request
    Rails.logger.debug("Create action: Data read: #{data.inspect}")
    data[:user_id] = current_user.id # Obtains user id from token, forces proper ownership
    data[:status] = "Pending" # Assigns default values that the front end doesnt supply. This abstracts these values from the user
    Rails.logger.debug("Create action: Defaults applied: #{data.inspect}")
    @reimbursement = Reimbursement.new(data)
    if @reimbursement.user_id != current_user.id # If the data somehow fails to match the token, nothing will be entered
      render json: { error: 'You are not authorized to create this reimbursement' }, status: :unauthorized
      Rails.logger.warn("Create action: Unauthorized. user_id in data doesn't match token")
    else
      if @reimbursement.save # If the data is saved to the database
        render json: { message: 'Reimbursement created'}, status: :created
        Rails.logger.info("Create action: Data successfully added to table")
      else
        render json: { message: 'Invalid reimbursement creation' }, status: :unprocessable_entity # If user input is somehow very wrong
        Rails.logger.error("Create action: Input was invalid")
      end
    end
  end

  def show # GET /reimbursements
    Rails.logger.info("Show action: Called") # Retrieves a single reimbursement based on ID
    @reimbursement = Reimbursement.find(params[:id])
    if owns? || authorized?
      render json: @reimbursement, status: :ok
      Rails.logger.info("Show action: Reimbursement displayed")
    else
      render json: { error: "Unauthorized: You don't own this reimbursement" }, status: :unauthorized
      Rails.logger.warn("Show action: Unauthorized access")
    end
  end

  def showUserReims # GET /reimbursements/showuserreims
    @reimbursement = Reimbursement.where(user_id: @current_user.id) # This retrieves all of a users reimbursements, without supplying an id. Works off of token. Used on homepage
    render json: @reimbursement, status: :ok
    Rails.logger.info("ShowUserReims action: Reimbursements displayed")
  end

  def update #PUT/PATCH /reimbursements/:id
    Rails.logger.info("Update action: Called")
    @reimbursement = Reimbursement.find(params[:id])

    if owns? || authorized? # Checks if either the user owns the specified reimbursement, if they're an admin. Only one of those needs to be true
      Rails.logger.info("Update action: Authorized")
      if @reimbursement.update(JSON.parse(request.body.read))
        render json: { message: 'Reimbursement updated' }, status: :ok
        Rails.logger.info('Update action: Reimbursement updated')
      else
        render @reimbursement.errors, status: :unprocessable_entity # If update somehow fails
        Rails.logger.error("Update action: Update could not be applied to the database")
      end
    else
      render json: { error: 'You are not authorized to update this reimbursement' }, status: :unauthorized
      Rails.logger.warn("Update action: User does not own or have admin privileges")
    end
  end

  def delete #Delete /reimbursements/:id
    Rails.logger.info("Delete Action: Called")
    @reimbursement = Reimbursement.find(params[:id])

    if owns? || authorized? # Checks if either the user owns the specified reimbursement, if they're an admin. Only one of those needs to be true
      Rails.logger.info("Delete Action: Authorized")
      @reimbursement.destroy
      head :ok
      Rails.logger.info("Delete Action: Reimbursement deleted from database")
    else
      render json: { error: 'You are not authorized to delete this reimbursement' }, status: :unauthorized
      Rails.logger.warn("Delete Action: User does not own or have admin privileges")
    end
  end

  def owns? # Compares user supplied ID with their actual ID from token, checks for ownership
    if @reimbursement.user_id == @current_user.id
      Rails.logger.info("Ownership check: User owns chosen reimbursement")
      return true
    else
      Rails.logger.info("Ownership check: User does not own chosen reimbursement")
      return false
    end
  end
end
