class ReimbursementsController < ApplicationController
  include Authenticatable
  def index # GET /reimbursements
    @reimbursement = Reimbursement.all
    render json: @reimbursement, status: :ok
  end

  def create # POST /reimbursements
    puts "create called"
    data = JSON.parse(request.body.read)
    reim_id = data[:id]
    # data[:user_id] = current_user.id
    @reimbursement = Reimbursement.new(data)
    if @reimbursement.user_id != current_user.id
      render json: { error: 'You are not authorized to create this reimbursement' }, status: :unauthorized
    else
      if @reimbursement.save
        render json: { message: 'Reimbursement created'}, status: :created
        puts "data added to table"
      else
        render json: { message: 'Invalid reimbursement creation' }
      end
    end
  end

  def show # GET /reimbursements/:id
    @reimbursement = Reimbursement.where(user_id: @current_user.id)
    puts Reimbursement.where(user_id: @current_user.id).to_sql
    if @reimbursement.nil?
      render json: { error: 'Not Found' }, status: :not_found
    else
      render json: @reimbursement
    end
  end

  def update #PUT/PATCH /reimbursements/:id
    @reimbursement = Reimbursement.find(params[:id])

    if @reimbursement.user_id != @current_user.id
      render json: { error: 'You are not authorized to update this reimbursement' }, status: :unauthorized
    else
      puts "Belongs to current user"
      if @reimbursement.update(JSON.parse(request.body.read))
        render json: { message: 'Request updated' }, status: :ok
      else
        render @reimbursement.errors, status: :unprocessable_entity
      end
    end

  end

  def delete #Delete /reimbursements/:id
    @reimbursement = Reimbursement.find(params[:id])

    if @reimbursement.user_id != @current_user.id
      render json: { error: 'You are not authorized to delete this reimbursement' }, status: :unauthorized
    else
      @reimbursement.destroy
      head :no_content
    end
  end
end
