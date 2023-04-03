class ReimbursementsController < ApplicationController
  def index # GET /reimbusements
    @reimbursement = Reimbursement.all
    render json: @reimbursement, status: :ok
  end

  def create # POST /reimbursements
    data = JSON.parse(request.body.read)
    reim_id = data[:id]
    # data[:user_id] = current_user.id
    @reimbursement = Reimbursement.new(data)
    if @reimbursement.save
      redirect_to json: { reimbursement: reim_id }
    else
      #TODO
      render json: @reimbursement_list.errors, status: :unprocessable_entity
    end
  end

  def show # GET /reimbursements/:id
    @reimbursement = Reimbursement.find(params[:id])
    render @reimbursement
  end

  def update #PUT/PATCH /reimbursements/:id
    @reimbursement = Reimbursement.find(params[:id])

    if @reimbursement.update(JSON.parse(request.body.read))
      head :no_content
    else
      render @reimbursement.errors, status: :unprocessable_entity
    end

  end

  def delete #Delete /reimbursements/:id
    @reimbursement = Reimbursement.find(params[:id])
    @reimbursement.destroy
    head :no_content #TODO
  end
end
